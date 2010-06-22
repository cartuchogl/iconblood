class UnitOption < ActiveRecord::Base
  attr_accessible :name, :unit_id, :cost, :move, :force, :skill, :resistance, :fly, :background_id,
    :equip_type, :use, :quantity, :image_id
end
