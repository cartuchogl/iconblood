class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.string :name
      t.integer :cost
      t.integer :faction_id
      t.integer :background_id
      t.integer :move
      t.integer :force
      t.integer :skill
      t.integer :resistance
      t.integer :move_type
      t.integer :max_equip
      t.integer :image_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :units
  end
end
