class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :environment_id
      t.integer :level_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :games
  end
end
