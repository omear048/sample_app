class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper #Sessions helper can be used for authentication; such helpers are automatically included in Rails view, so all we need to do to use the Sessions helper funtions in controllers is to include the module into the Application controller 
end
