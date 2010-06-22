class Unit < ActiveRecord::Base
  attr_accessible :name, :cost, :faction_id, :background_id, :move, :force, :skill, :resistance, 
    :move_type, :max_equip, :image_id
  belongs_to :faction
  belongs_to :background
  belongs_to :image
  has_many :unit_options
  has_many :squadron_units
end
