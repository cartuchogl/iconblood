class CreateLevels < ActiveRecord::Migration
  def self.up
    create_table :levels do |t|
      t.integer :position
      t.string :name
      t.integer :environment_id
      t.integer :campaign_id
      t.integer :pre_background_id
      t.integer :post_background_id
      t.integer :image_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :levels
  end
end
