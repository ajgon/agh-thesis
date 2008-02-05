class CreateUploadedFiles < ActiveRecord::Migration
  def self.up
    create_table :uploaded_files do |t|
      t.references :subject, :user
      t.string :filename, :null => false
      t.string :head, :null => false
      t.text :body
      t.datetime :date, :null => false
      t.string :kind, :limit => 15   # reference/material
    end
  end

  def self.down
    drop_table :uploaded_files
  end
end
