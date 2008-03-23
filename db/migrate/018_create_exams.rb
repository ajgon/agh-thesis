class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :subject, :null => false
      t.references :user, :null => false
      t.string :exams_name_id, :limit => 3, :null => false, :references => :exams_names
      t.string :examiner, :null => false
      t.datetime :date, :null => false
#      t.string :core, :null => false, :limit => 3
      t.string :place, :null => false
      t.integer :term, :null => false
    end
  end

  def self.down
    drop_table :exams
  end
end
