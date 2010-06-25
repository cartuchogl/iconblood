class UnitOption < ActiveRecord::Base
  attr_accessible :name, :unit_id, :cost, :move, :force, :skill, :resistance, :fly, :background_id,
    :equip_type, :use, :quantity, :image_id
  belongs_to :unit
  belongs_to :background
  belongs_to :image
  has_and_belongs_to_many :squadron_units
end
