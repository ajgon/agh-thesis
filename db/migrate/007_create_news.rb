class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.references :news_type, :user
      t.string :head, :null => false
      t.text :body, :null => false
      t.string :ip, :limit => 15
      t.date :datetime #, :null => false
      t.integer :times_readed, :null => false, :default => 0
      t.integer :for_year, :null => false
    end
  end

  def self.down
    drop_table :news
  end
end
