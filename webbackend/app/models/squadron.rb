class Squadron < ActiveRecord::Base
  attr_accessible :name, :player_id, :game_id, :image_id
end
