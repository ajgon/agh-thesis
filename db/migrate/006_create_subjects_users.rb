class CreateSubjectsUsers < ActiveRecord::Migration
  def self.up
    create_table :subjects_users, :id => false do |t|
      t.references :subject, :user
    end
  end

  def self.down
    drop_table :subjects_users
  end
end
