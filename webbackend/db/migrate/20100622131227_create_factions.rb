class CreateFactions < ActiveRecord::Migration
  def self.up
    create_table :factions do |t|
      t.string :name
      t.integer :image_id
      t.belongs_to :background
      t.timestamps
    end
  end
  
  def self.down
    drop_table :factions
  end
end
