class CreateNewsTypes < ActiveRecord::Migration
  def self.up
    create_table :news_types do |t|
      t.column :name, :string, :limit => 20, :null => false
    end
  end

  def self.down
    drop_table :news_types
  end
end
