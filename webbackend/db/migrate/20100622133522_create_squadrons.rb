class CreateSquadrons < ActiveRecord::Migration
  def self.up
    create_table :squadrons do |t|
      t.string :name
      t.integer :player_id
      t.integer :game_id
      t.integer :image_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :squadrons
  end
end
