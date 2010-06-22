class Unit < ActiveRecord::Base
  attr_accessible :name, :cost, :faction_id, :background_id, :move, :force, :skill, :resistance, :move_type, :max_equip, :image_id
end
