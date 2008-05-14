class CreateSubjectsTypes < ActiveRecord::Migration
  def self.up
    create_table :subjects_types, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.string :head, :limit => 50, :null => false
      t.boolean :mandatory, :null => false, :default => true
    end
  end

  def self.down
    drop_table :subjects_types
  end
end
