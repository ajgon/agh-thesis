class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.references :subject, :null => false
      t.references :user
      t.string :examiner, :null => false
      t.datetime :date, :null => false
      t.string :core, :null => false, :limit => 3
      t.string :place, :null => false
      t.integer :term, :null => false
    end
  end

  def self.down
    drop_table :exams
  end
end
