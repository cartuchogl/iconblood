class SquadronUnit < ActiveRecord::Base
  attr_accessible :squadron_id, :unit_id, :level, :exp, :position
end
