class Player < ActiveRecord::Base
  attr_accessible :alias, :email, :image_id
  belongs_to :image
  has_many :squadrons
end
