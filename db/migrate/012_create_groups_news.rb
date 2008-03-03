class CreateGroupsNews < ActiveRecord::Migration
  def self.up
    create_table :groups_news, :id => false, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :group, :news
    end
  end

  def self.down
    drop_table :groups_news
  end
end
