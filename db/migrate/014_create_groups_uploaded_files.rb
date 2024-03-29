class CreateGroupsUploadedFiles < ActiveRecord::Migration
  def self.up
    create_table :groups_uploaded_files, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :group, :null => false, :default => 2
      t.references :uploaded_file, :null => false
    end
  end

  def self.down
    drop_table :groups_uploaded_files
  end
end
