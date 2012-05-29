# -*- encoding : utf-8 -*-
require 'digest/md5'


class SessionsController < Devise::SessionsController

  before_filter :authenticate_user!, :only => [:edit, :update, :destroy, :accounts, :send_confirmation]
  before_filter  :is_admin?, :only => [:index, :confirm, :approve]


  def create
    @user = User.new(params[:user])
    #@user.skip_confirmation! if SKIP_CONFIRM
    @user.captcha = session['captchaCodes'] && params['captcha'] && params['captcha'].slice(10,params['captcha'].length) == session['captchaCodes'][session['captchaAnswer']]
    @user.captcha = @user.captcha ? true : false
    logger.info "Captcha result: #{@user.captcha}"

    if @user.save
      @user.chain!(session["click"] || cookies["click"])
      flash[:"#{:user}_signed_up"] = true
      set_flash_message :notice, :signed_up
      #ContactMailer.delay.deliver_welcome_email(@user)
      logger.info("Sending welcome email")
      if @user.chained?
        sign_in(:user, @user)
        redirect_to go_campaign_tips_path(@user.chain.campaign_id)
      else
        sign_in_and_redirect(:user, @user)
      end
    else
      render 'registrations/new', :layout => "application"
    end
  end

  def update
    @user = current_user

    if @user.encrypted_password.blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      @user.update_attributes(params[:user])

      @user.clean_up_passwords
    else
      @user.update_with_password(params[:user])
    end
    logger.info "Setting user locale to: #{@user.locale}"
    cookies[:locale]=@user.locale

    respond_to do |format|
      if @user.valid?
         flash[:notice] = "user.updated"
        format.html { redirect_to(:action => "edit") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end

  end

  def complete_signup
    @user = User.new
    @user.apply_omniauth(session[:omniauth])
    render :layout => "application"
  end

  def edit
    @user = current_user

  end


  def update_signup
    @user = User.new(params[:user])
    @user.apply_omniauth(session[:omniauth])
    #@user.skip_confirmation!

    if @user.save
      flash["#{:user}_signed_up"] = true
      @user.chain!(session["click"] ||cookies["click"])
      set_flash_message :notice, :signed_up
      #ContactMailer.delay.deliver_welcome_email(@user)
      if @user.chained?
        sign_in(:user, @user)
        redirect_to go_campaign_tips_path(@user.chain.campaign_id)
      else
        sign_in_and_redirect(:user, @user)
      end
    else
      render :action => :complete_signup, :layout => "application"
    end

  end



end

