class Image < ActiveRecord::Base
  attr_accessible :title, :data
  
  has_many :factions
  has_many :pages
  has_many :campaigns
  has_many :levels
  has_many :environments
  has_many :players
  has_many :squadrons
  has_many :units
  has_many :unit_options
  
  has_attached_file :data, :styles => { 
    :medium => "1024x480>", 
    :small => "128x128>", 
    :thumb => "48x48>" 
  }
end
