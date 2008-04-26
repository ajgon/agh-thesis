class CreatePollsAnswers < ActiveRecord::Migration
  def self.up
    create_table :polls_answers, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :polls_question, :null => false
      t.string :answer, :null => false, :limit => 200
      t.integer :quantity, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :polls_answers
  end
end
