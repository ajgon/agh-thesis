class CreateDeclarationsExperiences < ActiveRecord::Migration
  def self.up
    create_table :declarations_experiences, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :declaration, :null => false
      t.string :firstname, :null => false
      t.string :lastname, :null => false
      t.integer :sindex, :limit => 6, :null => false
      t.references :speciality, :null => false
      t.string :student_street, :null => false
      t.string :student_postal_code, :null => false
      t.string :student_city, :null => false
      t.string :place_name, :null => false
      t.string :place_street, :null => false
      t.string :place_postal_code, :null => false
      t.string :place_city, :null => false
      t.date :beginning, :null => false
      t.date :beginning_additional
      t.date :ending_additional
      t.boolean :dormitory, :null => false, :default => false
      t.string :policy_type
      t.string :policy_name
      t.string :policy_number
      t.integer :confirmations
      t.timestamps
    end
  end

  def self.down
    drop_table :declarations_experiences
  end
end
