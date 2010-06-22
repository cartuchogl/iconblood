class Campaign < ActiveRecord::Base
  attr_accessible :background_id, :image_id
  belongs_to :background
  belongs_to :image
  has_many :levels
end
