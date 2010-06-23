# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  private
  def attach_image(obj,param,title)
    unless param.blank?
      unless obj.image
        obj.reload
        obj.create_image(:title=>title)
        obj.save
      end
      obj.image.data = param
      obj.image.save
    end
  end
end
