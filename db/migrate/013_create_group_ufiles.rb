class CreateGroupUfiles < ActiveRecord::Migration
  def self.up
    create_table :group_ufiles do |t|
      t.column :group_id, :integer, :null => false
      t.column :ufile_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :group_ufiles
  end
end
