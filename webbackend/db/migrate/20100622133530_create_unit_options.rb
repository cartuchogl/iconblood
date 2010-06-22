class CreateUnitOptions < ActiveRecord::Migration
  def self.up
    create_table :unit_options do |t|
      t.string :name
      t.integer :unit_id
      t.integer :cost
      t.integer :move
      t.integer :force
      t.integer :skill
      t.integer :resistance
      t.boolean :fly
      t.integer :background_id
      t.integer :equip_type
      t.integer :use
      t.integer :quantity
      t.integer :image_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :unit_options
  end
end
