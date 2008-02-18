class CreateGroupsNews < ActiveRecord::Migration
  def self.up
    create_table :groups_news, :id => false do |t|
      t.references :group, :new
    end
  end

  def self.down
    drop_table :groups_news
  end
end
