require "#{RAILS_ROOT}/config/environment.rb"
require 'cgi'

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

class OriginalBase < ActiveRecord::Base
end
class ConvertedBase < ActiveRecord::Base
end

class ConvertMap
  def self.load_path(path, filename)
    YAML.load_file(
      File.join(path, filename)
    )
  end
  
  def self.load_file(filename)
    self.load_path(
      File.join(File.dirname(__FILE__), '..', '..', 'config'),
      filename
    )
  end
  
  def self.load
    self.load_file 'convert_map.yml'
  end
end

class Converter
  def initialize(old_base_details, new_base_details)
    @old_base_details, @new_base_details = old_base_details, new_base_details
  end
  
  def convert(schema)
    @id_map = {}
    schema.sort.each do |hash|
      new_table_name = hash[0].gsub(/^[0-9]+[a-z]?_/, '')
      old_tables = hash[1]
      parse_new_table new_table_name
      old_tables.each_pair do |old_table_name, with_rules|
        parse_old_table old_table_name
        port_data with_rules
      end
    end
  end
  
  private
  def parse_new_table(new_table_name)
    begin
      @NewModel = new_table_name.classify.constantize
    rescue
      raise 'Can\'t find model ' + new_table_name.classify.to_s + ' - wrong ' +
            'migrations or mispelled new table name'
    end
  end
  
  def parse_old_table(old_table_name)
    begin
      Object.const_set("OldTable", Class.new(ActiveRecord::Base))
      OldTable.set_table_name old_table_name
      OldTable.establish_connection @old_base_details
      OldTable.inheritance_column = 'cb757e5dca' # SAT hack
      @OldTable = OldTable
      raise 'Wrong table name given (' + old_table_name + ')' unless @OldTable.table_exists?
    rescue
      raise 'Can\'t find table ' + old_table_name + ' in specified connection'
    end
  end
  
  # port_data
  def port_data(rules)
    conversion_log = File.new(File.join(File.dirname(__FILE__), '..', '..', 'log', 'conversion.log'), 'w+')
    rules = rules.nil? ? {} : rules
    unless rules['__BEFORE'].nil?
      @OldTable.connection.execute(rules['__BEFORE'].sub('@', @OldTable.table_name))
      rules.delete '__BEFORE'
    end
    after_query = rules['__AFTER']
    rules.delete '__AFTER'
    where = (rules['__WHERE'].nil? ? '1' : rules['__WHERE'])
    rules.delete '__WHERE'
    populate_maps rules
    @OldTable.find(:all, :order => (@OldTable.column_names.include?('id') ? 'id' : '1'), :conditions => where).each do |row|
      begin
        old_id = row.id
        new_row = remap_columns(
          sync_columns_with_map(
            row.attributes
          )
        )
        new_row = fix_related_columns new_row
        new_row = fix_not_null_columns new_row
        new_row = fix_entities new_row
        new_row = convert_encodings new_row
        new_row = apply_functions new_row
        new_row = apply_connections new_row, row

        insertion = @NewModel.new(new_row)
        insertion.save_without_validation!
        new_id = insertion.id
        @id_map[@NewModel.table_name]['id_map'][old_id] = new_id
      rescue Exception => e
        conversion_log.puts e.inspect
        puts e.inspect
      end
    end
    unless after_query.nil?
      @OldTable.connection.execute(after_query.sub('@', @OldTable.table_name))
    end
    conversion_log.close
  end
  
  def populate_maps rules
    @id_map[@NewModel.table_name] = {}
    @id_map[@NewModel.table_name]['old_name'] = @NewModel.table_name
    @id_map[@NewModel.table_name]['id_map'] = {}
    @map = create_column_map(populate(rules))
    @relation_map = create_relation_map rules
    @function_map = create_function_map(populate(rules))
    @connections_map = create_connections_map(populate(rules))
  end
  
  def create_function_map rules
    function_map = {}
    rules.each_pair do |key, value|
      if value.has_key? 'function'
        function_map[value['name']] = value['function']
      end
    end
    function_map
  end
  
  def create_connections_map rules
    connections_map = {}
    rules.each_pair do |key, value|
      if value.has_key? 'connect' and value.has_key? 'pattern'
        connections_map[value['name']] = {}
        connections_map[value['name']]['connect'] = value['connect']
        connections_map[value['name']]['pattern'] = value['pattern']
      end
    end
    connections_map
  end
  
  def create_relation_map rules
    related_columns = populate(rules).clone
    related_columns.delete_if do |column_name, params|
      params['from'].nil?
    end
    relation_map = {}
    additional_relation_map = {}
    unless related_columns.empty?
      begin
        related_columns.each_pair do |column, params|
          relation_map[params['name']] = @id_map[params['from']]['id_map']      
          unless params['field'].nil?
            additional_relation_map[params['name']] = {}
            Object.const_set("FromTable", Class.new(ActiveRecord::Base))
            FromTable.set_table_name params['from']
            FromTable.establish_connection @new_base_details
            FromTable.inheritance_column = 'cb757e5dca' # SAT hack
            relation_map[params['name']].each_pair do |id_from, id_to|
              additional_relation_map[params['name']][FromTable.find(id_to)[params['field']]] = id_to
            end
          end
        end
        relation_map.keys.each do |key|
          relation_map[key] = relation_map[key].merge additional_relation_map[key] unless additional_relation_map[key].nil?
        end
      rescue
        raise 'An error occured while creating relation map. Did you map tables used in \'from\' field before?'
      end
    end
    relation_map
  end
  
  def sync_columns_with_map row
    row_clone = row.clone
    row_clone.delete_if do |column_name, value|
      !@map.has_key? column_name
    end
    row_clone
  end
  
  def remap_columns row
    new_row = {}
    row.each_pair do |column_name, value|
      new_value = value
      new_column = @NewModel.columns.find_all { |column| column.name == @map[column_name]}.first
      unless new_column.nil?
        new_row[@map[column_name]] = new_value
      end
    end
    new_row
  end

  def fix_not_null_columns row
    new_row = row.clone
    row.each_pair do |column_name, value|
      new_column = @NewModel.columns.find_all { |column| column.name == column_name}.first
      unless new_column.nil?
        column_not_null = !new_column.null
        column_default = new_column.default
        new_row[column_name] = column_default if column_not_null and new_row[column_name].nil?
      end
    end
    new_row
  end
  
  def fix_related_columns new_row
    unless @relation_map.empty? 
      new_row.each_pair do |column_name, value|
        @relation_map.each_pair do |relation_map_column, id_map|
          if relation_map_column == column_name
            new_row[column_name] = id_map[new_row[column_name]]
          end
        end
      end
    end
    new_row
  end

  def fix_entities new_row
    new_row.each_pair do |name, value| 
      new_row[name] = CGI::escapeHTML(CGI::unescapeHTML(value)).gsub("'", '&#039;') if value.class.to_s == 'String'
    end
    new_row
  end
  
  def convert_encodings new_row
    new_row.each_pair do |name, value| 
      new_row[name] = Iconv.conv(@new_base_details['encoding'].upcase.sub('UTF8', 'UTF-8'), @old_base_details['encoding'].upcase.sub('UTF8', 'UTF-8'), value) if value.class.to_s == 'String'
    end
    new_row
  end

  def apply_functions new_row
    @function_map.each_pair do |column, function|
      new_row[column] = parse_function(function.gsub('@@', @old_base_details['database']).gsub('@', '\'' + new_row[column].to_s + '\''))
    end
    new_row
  end
  
  def apply_connections new_row, row
    @connections_map.each_pair do |column, connection|
      pattern = connection['pattern']
      connection['connect'].split(',').each do |column_name|
        pattern = pattern.gsub(Regexp.new('\{(' + column_name.strip + ')\}')) {row[$1]}
      end
      new_row[column] = pattern
    end
    new_row
  end

  #---
  
  def populate(rules)
    if rules.nil? 
      rules = {} 
    end
    rules.each_pair do |column_name, params|
      params['action'] = 'copy' if params['action'].nil?
      params['name'] = column_name if params['name'].nil?
    end
    rules
  end
  
  def create_column_map rules
    map = {}
    @OldTable.columns_hash.keys.each do |column_name|
      map[column_name] = column_name
    end
    rules.each_pair do |old_column_name, params|
      map[old_column_name] = params['name']
    end
    rules.each_pair do |old_column_name, params|
      map.delete_if do |old_column, new_column|
        (params['action'] == 'remove' and old_column == old_column_name) or
          (old_column == 'id' and new_column == 'id')
      end
    end
    map
  end
  
  def parse_function function
    @NewModel.connection.select_one('SELECT ' + function).to_a.first.last.to_s
  end
  
end

namespace :eit do
  namespace :db do
    desc 'Converts data from old database to new one'
    task :convert => :environment do
      schema = ConvertMap.load
      converter = Converter.new(
        ActiveRecord::Base.configurations['original'],
        ActiveRecord::Base.configurations['converted']
      )
      converter.convert schema
    end
  end
end
