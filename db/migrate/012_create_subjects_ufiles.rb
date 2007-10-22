class CreateSubjectsUfiles < ActiveRecord::Migration
  def self.up
    create_table :subjects_ufiles do |t|
      t.column :subject_id, :integer, :null => false
      t.column :ufile_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :subjects_ufiles
  end
end
