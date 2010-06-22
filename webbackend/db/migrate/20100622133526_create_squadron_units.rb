class CreateSquadronUnits < ActiveRecord::Migration
  def self.up
    create_table :squadron_units do |t|
      t.integer :squadron_id
      t.integer :unit_id
      t.integer :level
      t.integer :exp
      t.integer :position
      t.timestamps
    end
  end
  
  def self.down
    drop_table :squadron_units
  end
end
