class CreateUploadedFiles < ActiveRecord::Migration
  def self.up
    create_table :uploaded_files, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :subject, :user, :null => false
      t.integer :uploader_id, :null => false, :references => :users
      t.string :filename, :null => false
      t.string :head, :null => false
      t.text :body
      t.datetime :date, :null => false
      t.string :kind, :limit => 15   # reference/material
      t.integer :downloads, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :uploaded_files
  end
end
