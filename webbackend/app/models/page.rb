class Page < ActiveRecord::Base
  attr_accessible :position, :image_id, :background_id, :txt
  belongs_to :background
  belongs_to :image
end
