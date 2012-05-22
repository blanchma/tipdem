# -*- encoding : utf-8 -*-
class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:destroy]

  def send_confirmation
    @user = User.new
    @authentication = @user.apply_omniauth(session[:omniauth])
    @authentication.generate_token! if self.verify_token.nil?
    @authentication.save
    UserMailer.delay.deliver_confirm_authentication(@user.email, @authentication)
  end

  def confirm
    @authentication = Authentication.find_by_verify_token params[:id]
    if @authentication
      @authentication.verify_token = nil
      @authentication.user_id =  params[:user_id]
      @authentication.save
    else
      head 404
    end
  end

  def destroy
    @user = current_user
    auth = @user.authentications.find params[:id]

    respond_to do |format|
      if auth
        auth.destroy
        flash[:notice]="Desvinculado exitosamente"
        format.html { redirect_to :back }
      else
        logger.error "Problema al desvincular #{@user.email} de cuenta: #{params[:auth]} "
        format.html { redirect_to :back }
      end
    end
  end


  private
  #current_user is the user who's logged in
  def twitter_wrapper
    @wrapper = TwitterWrapper.new session
  end

  protected
  def set_flash_message(key, kind, now=false)
    flash_hash = now ? flash.now : flash
    flash_hash[key] = I18n.t(:"#{:user}.#{kind}",
      :scope => [:devise, controller_name.to_sym], :default => kind)
  end

  private
  def set_fb_hash_from_token(fb_token)
    @fb = MiniFB::OAuthSession.new(fb_token, 'EN')
    friends = @fb.me.friends.data.count
    gender = @fb.me.gender
    birthday = @fb.me.try(:birthday)
    email = @fb.me.try(:email)
    session[:omniauth] = {:provider => Channel::Facebook, :uid => @fb.me.id, :token => fb_token,
      :name => @fb.me.name || @fb.me.username, :friends_count => friends, :gender => gender, :birthday => birthday, :email => email}
  end

end

