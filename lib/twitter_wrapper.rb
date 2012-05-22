# -*- encoding : utf-8 -*-
require 'twitter'

class TwitterWrapper

  attr_accessor :key, :secret, :callback_url, :auth

  def initialize(session=nil)
    @key = APP_CONFIG['twitter_key']
    @secret = APP_CONFIG['twitter_secret']
    @callback_url = APP_CONFIG['callback_twitter']

    @auth = Twitter::OAuth.new key, secret
    @session = session
  end

  def request_tokens
    rtoken = @auth.request_token :oauth_callback => @callback_url
    [rtoken.token, rtoken.secret]
  end

  def authorize_url
    @auth.request_token(:oauth_callback => @callback_url).authorize_url
  end

  def auth_from_request(rtoken, rsecret, verifier)
    @auth.authorize_from_request(rtoken, rsecret, verifier)
    @session[:twitter_token], @session[:twitter_secret] = @auth.access_token.token, @auth.access_token.secret
  end

 

  def access_token
    @auth.access_token
  end

  def get_twitter(token, secret)
    @auth.authorize_from_access(token, secret)
    twitter = Twitter::Base.new @auth
    twitter.home_timeline(:count => 1)
    twitter
  end

end
