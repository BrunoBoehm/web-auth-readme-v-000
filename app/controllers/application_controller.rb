class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user
  # all action will require to be authenticated (except the skip_before_action in the sessions_controller)


  private

  	# following https://developer.foursquare.com/overview/auth guidelines
  	def authenticate_user
  		client_id = ENV['FOURSQUARE_CLIENT_ID']
  		# will write as http%3A%2F%2Flocalhost%3A3000%2Fauth as needed by the foursquare_url
  		redirect_uri = CGI.escape("http://localhost:3000/auth")
  		foursquare_url = "https://foursquare.com/oauth2/authenticate?client_id=#{client_id}&response_type=code&redirect_uri=#{redirect_uri}"
  		redirect_to foursquare_url unless logged_in?
  	end

  	def logged_in?
  		!!session[:token]
  	end  	
end
