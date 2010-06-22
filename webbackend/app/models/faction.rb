class Faction < ActiveRecord::Base
  attr_accessible :name, :image_id
  belongs_to :background
  belongs_to :image
  has_many :units
end
