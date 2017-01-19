class SearchesController < ApplicationController
  def search
  end

  def foursquare

    client_id = ENV['FOURSQUARE_CLIENT_ID']
    client_secret = ENV['FOURSQUARE_SECRET']

    @resp = Faraday.get 'https://api.foursquare.com/v2/venues/search' do |req|
      req.params['client_id'] = client_id
      req.params['client_secret'] = client_secret
      req.params['v'] = '20160201'
      req.params['near'] = params[:zipcode]
      req.params['query'] = 'coffee shop'
    end

    body = JSON.parse(@resp.body)

    if @resp.success?
      @venues = body["response"]["venues"]
    else
      @error = body["meta"]["errorDetail"]
    end
    render 'search'

    rescue Faraday::TimeoutError
      @error = "There was a timeout. Please try again."
      render 'search'
  end


  def friends
    resp = Faraday.get("https://api.foursquare.com/v2/users/self/friends") do |req|
      req.params['oauth_token'] = session[:token]
      # don't forget that pesky v param for versioning
      req.params['v'] = '20160201'
    end

    # {"meta"=>{"code"=>200, "requestId"=>"5880c98d6a607168b4e66230"}, "notifications"=>[{"type"=>"notificationTray", "item"=>{"unreadCount"=>0}}], "response"=>{"friends"=>{"count"=>0, "items"=>[]}, "checksum"=>"07de1832f293e704795285aab6a48e7e0dcdd3b8"}}
    @friends = JSON.parse(resp.body)["response"]["friends"]["items"]
  end
end
