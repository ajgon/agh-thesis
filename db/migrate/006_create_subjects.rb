class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.string :acronym, :limit => 10, :null => false
      t.string :head, :null => false
      t.text :body
      t.string :code, :limit => 6
      t.integer :season, :limit => 4, :null => false
    end
  end

  def self.down
    drop_table :subjects
  end
end
