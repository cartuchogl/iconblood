class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :position
      t.integer :image_id
      t.integer :background_id
      t.text :txt
      t.timestamps
    end
  end
  
  def self.down
    drop_table :pages
  end
end
