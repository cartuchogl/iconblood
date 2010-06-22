class Environment < ActiveRecord::Base
  attr_accessible :name, :image_id
  belongs_to :image
  has_many :games
  has_many :levels
end
