class Level < ActiveRecord::Base
  attr_accessible :position, :name, :environment_id, :campaign_id, :pre_background_id,
    :post_background_id, :image_id
  belongs_to :environment
  belongs_to :campaign
  belongs_to :image
  belongs_to :pre_background, :class_name => "Background", :foreign_key => "pre_background_id"
  belongs_to :post_background, :class_name => "Background", :foreign_key => "post_background_id"
  has_many :games
end
