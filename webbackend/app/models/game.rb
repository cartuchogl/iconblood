class Game < ActiveRecord::Base
  attr_accessible :environment_id, :level_id
  belongs_to :level
  belongs_to :environment
  has_many :squadrons
end
