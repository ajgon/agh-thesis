class CreateUfiles < ActiveRecord::Migration
  def self.up
    create_table :ufiles do |t|
      t.column :filename, :string, :null => false
      t.column :head, :string, :null => false
      t.column :body, :text
      t.column :date, :timestamp, :null => false
      t.columns << 'kind enum(\'reference\', \'grade\') NOT NULL'
    end
    execute 'ALTER TABLE ufiles CHANGE date date timestamp(14) NOT NULL'
  end

  def self.down
    drop_table :ufiles
  end
end
