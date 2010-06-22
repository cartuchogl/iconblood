class Background < ActiveRecord::Base
  attr_accessible :name
  has_many :pages
  has_many :factions
  has_many :units
  has_many :unit_options
  has_many :campaigns
  has_many :pre_levels, :class_name => "Level", :foreign_key => "pre_background_id"
  has_many :post_levels, :class_name => "Level", :foreign_key => "post_background_id"
end
