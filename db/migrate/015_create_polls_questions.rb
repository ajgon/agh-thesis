class CreatePollsQuestions < ActiveRecord::Migration
  def self.up
    create_table :polls_questions, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :user, :null => false
      t.string :question, :null => false
      t.datetime :start_time, :null => false
      t.datetime :end_time
      t.boolean :anonymous, :null => false, :default => false
    end
  end

  def self.down
    drop_table :polls_questions
  end
end
