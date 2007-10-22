class CreateSubjectUsers < ActiveRecord::Migration
  def self.up
    create_table :subject_users do |t|
      t.column :user_id, :integer, :null => false
      t.column :subject_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :subject_users
  end
end
