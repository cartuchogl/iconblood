class SquadronUnit < ActiveRecord::Base
  attr_accessible :squadron_id, :unit_id, :level, :exp, :position
  belongs_to :squadron
  belongs_to :unit
  has_and_belongs_to_many :unit_options
end
