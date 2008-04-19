class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :news_type
      t.references :user, :null => false
      t.references :subject
      t.string :head, :null => false
      t.text :body, :null => false
      t.string :ip, :limit => 15
      t.datetime :date #, :null => false
      t.integer :times_readed, :null => false, :default => 0
      t.integer :for_year, :null => false
    end
  end

  def self.down
    drop_table :news
  end
end
