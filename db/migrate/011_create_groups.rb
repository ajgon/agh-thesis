require 'active_record/fixtures'

class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :user
      t.string :head, :null => false
      t.text :body
    end
    Fixtures.create_fixtures( 
      File.join(File.dirname(__FILE__), '..', '..', 'test', 'fixtures'),
      'groups'
    )
  end

  def self.down
    drop_table :groups
  end
end
