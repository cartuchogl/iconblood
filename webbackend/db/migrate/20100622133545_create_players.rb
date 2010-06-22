class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :alias
      t.string :email
      t.integer :image_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :players
  end
end
