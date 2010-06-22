class AddSquadronsUnitsUnitOptions < ActiveRecord::Migration
  def self.up
    create_table :squadron_units_unit_options, :force => true do |t|
      t.belongs_to :squadron_unit
      t.belongs_to :unit_option
      t.timestamps
    end
  end

  def self.down
    drop_table :squadron
  end
end
