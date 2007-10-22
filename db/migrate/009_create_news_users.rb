class CreateNewsUsers < ActiveRecord::Migration
  def self.up
    create_table :news_users do |t|
      t.column :new_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :news_users
  end
end
