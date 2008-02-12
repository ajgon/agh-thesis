class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.string :acronym, :limit => 10, :null => false
      t.string :head, :null => false
      t.text :body
      t.string :code, :limit => 6
    end
  end

  def self.down
    drop_table :subjects
  end
end
