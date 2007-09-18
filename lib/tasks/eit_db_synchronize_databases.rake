require "#{RAILS_ROOT}/config/environment.rb"
require 'digest/sha1'

class FalseClass
  def to_i
    0
  end
end

class OldBase < ActiveRecord::Base
end
class NewBase < ActiveRecord::Base
end

class Fields
  def self.parse table_name, field, changed_fields, removed_fields, not_null_fields, remove_id = true
    
    if remove_id
      removed_fields << 'id'
      removed_fields.uniq!
    end
    
    result = 'INSERT INTO ' + table_name + ' ('
    field_keys = field.keys
    field_values = []
    field.values.each do |value|
      field_values << (value.nil? ? 'NULL' : ( value.to_i.to_s == value ? value : '\'' + value.to_s.gsub(/[^']'[^']/, '') + '\''))
    end    

    removed_fields.each_index do |removed_fields_index|
      field_keys.each_index do |field_keys_index|
        if field_keys[field_keys_index] == removed_fields[removed_fields_index]
          field_keys.delete_at field_keys_index
          field_values.delete_at field_keys_index
        end
      end
    end
 
    changed_fields.each_index do |changed_fields_index|
      from = changed_fields[changed_fields_index].gsub(/:.*$/, '')
      to = changed_fields[changed_fields_index].gsub(/^.*:/, '')
      field_keys.each_index do |field_keys_index|
        if field_keys[field_keys_index] == from
          field_keys[field_keys_index] = to
        end
      end
    end

    not_null_fields.each_index do |not_null_fields_index|
      field_keys.each_index do |field_keys_index|
        if field_keys[field_keys_index] == not_null_fields[not_null_fields_index]
          if field_values[field_keys_index] == 'NULL'
            return false
          end
        end
      end
    end
   
 
    result += field_keys.join ','
    result += ') VALUES ('
    result += field_values.join ','
    result += ')'

    return result
  end
end

namespace :eit do
  desc 'Ports data from old database to new format'
  task :synchronize_databases => :environment do
    DB_CONFIG = YAML::load(File.open("#{RAILS_ROOT}/config/database.yml"))
    OldBase.establish_connection(DB_CONFIG['original'])
    NewBase.establish_connection(DB_CONFIG[(ENV['RAILS_ENV'])])
    
    # Users synchronization
    
    changed_fields = [
      'pass:password',
      'time:registered',
      'timeact:last_activity',
      'surname:lastname',
      'priv:privileges',
      'www:www_page',
      'wwwdesc:www_description',
    ]
    removed_fields = [
      's_hydview',
      'sunuml'
    ]
    not_null_fields = [
      'login'
    ]
    old_users = OldBase.connection.select_all 'SELECT * FROM users'
    NewBase.connection.delete 'DELETE FROM users'
    old_users.each do |field|
      field['activated'] = false if field['activated'].nil?
      field['priv'] = '0' if field['priv'].nil?
      field['email'] = '' if field['email'].nil?
      field['voted'] = false if field['voted'].nil?
      field['pass'] = Digest::SHA1.hexdigest field['pass'].to_s
      sql_query = Fields.parse('users', field, changed_fields, removed_fields, not_null_fields)
      NewBase.connection.insert sql_query if sql_query
    end
    
    changed_fields = [
      'band:group',
      'indeks:index',
      'gg:gadu_gadu',
      'id:users_id'
      #'nband:new_group'
    ]
    removed_fields = [
      'modified',
      'nband'
    ]
    not_null_fields = [
      'group'
    ]
    old_users_k1 = OldBase.connection.select_all 'SELECT * FROM users_k1'
    NewBase.connection.delete 'DELETE FROM users_students'
    old_users_k1.each do |field|
      login = (OldBase.connection.select_one 'SELECT login FROM users WHERE id = ' + field['id'])['login']
      if login
        new_id = (NewBase.connection.select_one 'SELECT id FROM users WHERE login = \'' + login + '\'')['id']
        field['id'] = new_id
        sql_query = Fields.parse('users_students', field, changed_fields, removed_fields, not_null_fields, false)
        NewBase.connection.insert sql_query if sql_query
      end
    end
  end
end