class CreateSpecialities < ActiveRecord::Migration
  def self.up
    create_table :specialities, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.string :head, :limit => 50, :null => false
    end
    Speciality.new({'head' => ''}).save!
    Speciality.new({'head' => 'Elektronika'}).save!
    Speciality.new({'head' => 'Telekomunikacja'}).save!
  end

  def self.down
    drop_table :specialities
  end
end
