require "#{RAILS_ROOT}/config/environment.rb"

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
      new_table_name = hash[0].gsub(/^[0-9]+_/, '')
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
            'migrations or misspelled new table name'
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
  
  def populate_maps rules
    @map = create_column_map(populate(rules))
    @relation_map = create_relation_map rules
    @id_map[@NewModel.table_name] = {}
    @id_map[@NewModel.table_name]['old_name'] = @NewModel.table_name
    @id_map[@NewModel.table_name]['id_map'] = {}
  end
  
  def create_relation_map rules
    related_columns = populate(rules)
    related_columns.delete_if do |column_name, params|
      params['from'].nil?
    end
    relation_map = {}
    unless related_columns.empty?
      related_columns.each_pair do |column, params|
        relation_map[params['name']] = @id_map[params['from']]['id_map']      
      end
    end
    relation_map
  end
  
  def sync_columns_with_map row
    row.delete_if do |column_name, value|
      !@map.has_key? column_name
    end
    row
  end
  
  def fix_not_null_columns row
    new_row = {}
    row.each_pair do |column_name, value|
      new_value = value
      new_column = @NewModel.columns.find_all { |column| column.name == @map[column_name]}.first
      column_not_null = !new_column.null
      column_default = new_column.default
      new_value = column_default if new_value.nil? and column_not_null
      new_row[@map[column_name]] = new_value
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
  
  def port_data(rules)
    populate_maps rules
    @OldTable.find(:all).each do |row|
      begin
        old_id = row.id
        new_row = fix_not_null_columns(
          sync_columns_with_map(
            row.attributes
          )
        )
        new_row = fix_related_columns new_row
        insertion = @NewModel.new(new_row)
        insertion.save!
        new_id = insertion.id
        @id_map[@NewModel.table_name]['id_map'][old_id] = new_id
      rescue Exception => e
        puts e.inspect
        #TODO: Log wrong inserts
      end
    end
  end
  
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