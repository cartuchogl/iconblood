class Squadron < ActiveRecord::Base
  attr_accessible :name, :player_id, :game_id, :image_id
  belongs_to :player
  belongs_to :game
  belongs_to :image
  has_many :squadron_units
end
