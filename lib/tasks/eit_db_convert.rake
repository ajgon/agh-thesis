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
    schema.each_pair do |new_table_name, old_tables|
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
      @OldTable = OldTable
      raise 'Wrong table name given (' + old_table_name + ')' unless @OldTable.table_exists?
    rescue
      raise 'Can\'t find table ' + old_table_name + ' in specified connection'
    end
  end
  
  def port_data(rules)
    map = create_column_map(populate(rules))
    @OldTable.find(:all).each do |row|
      new_row = {}
      row = row.attributes
      row.delete_if do |column_name, value|
        !map.has_key? column_name
      end
      row.each_pair do |column_name, value|
        new_value = value
        new_column = @NewModel.columns.find_all { |column| column.name == map[column_name]}.first
        column_not_null = !new_column.null
        column_default = new_column.default
        new_value = column_default if new_value.nil? and column_not_null
        new_row[map[column_name]] = new_value
      end
      begin
      @NewModel.new(new_row).save!
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
      params['action'] = 'remove' if params['name'] == 'id'
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
          old_column == 'id' or new_column == 'id'
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