class CreateNewsTypes < ActiveRecord::Migration
  def self.up
    create_table :news_types, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.string :name, :limit => 20, :null => false
    end
  end

  def self.down
    drop_table :news_types
  end
end
