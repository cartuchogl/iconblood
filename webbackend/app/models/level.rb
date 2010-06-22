class Level < ActiveRecord::Base
  attr_accessible :position, :name, :environment_id, :campaign_id, :pre_background_id, :post_background_id, :image_id
end
