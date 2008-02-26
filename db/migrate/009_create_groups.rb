class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.string :code, :limit => 80
      t.string :head, :null => false
      t.text :body
    end
  end

  def self.down
    drop_table :groups
  end
end
