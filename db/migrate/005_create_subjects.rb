class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.column :user_id, :integer, :null => false
      t.column :head, :string, :null => false
      t.column :body, :text
    end
  end

  def self.down
    drop_table :subjects
  end
end
