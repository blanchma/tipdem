# -*- encoding : utf-8 -*-
require 'digest/md5'


class UsersController < ApplicationController
  layout 'panel'

  before_filter :authenticate_user!, :only => [:edit, :update, :destroy, :accounts, :send_confirmation]
  before_filter  :is_admin?, :only => [:index, :confirm, :approve]


  def destroy
    if user_signed_in?
      logger.info "User #{current_user.email} ask to destroy: #{current_user.email}"
      @user = User.find(params[:id])
      if current_user.id ==  @user.id
        @user.destroy
        cookies[:fb_token]=nil
        sign_out_and_redirect(root_path)
      elsif current_user.admin
        @user.destroy
        flash[:notice]="Usuario borrado"
        redirect_to :back
      else
        logger.info "El usuario no tiene permisos para remover al usuario"
        flash[:notice]="Usuario borrado"
        redirect_to :back
      end
    else
      flash[:alert]= t "devise.user.sessions.unauthenticated"
      redirect_to new_user_session_path
    end

  end


  def new
    @user = User.new
    render 'registrations/new', :layout => "application"
  end

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


  def index
    if params[:approved] == "false"
      @users = User.find_all_by_approved(false)
    else
      @users = User.all
    end
    render :layout => 'admin'
  end


  def approve
    @user = User.find params[:id]
    @user.approve!
    @user.save
    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end

  def confirm
    @user = User.find params[:id]
    @user.skip_confirmation!
    @user.save
    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end

  def toggle_recommendations
    current_user.email_recommendations = !current_user.email_recommendations
    current_user.save
    respond_to do |format|
      format.js do
        render :update do |page|
          page << "$('#email_recommendations').html('#{current_user.email_recommendations ? "Desuscribir" : "Suscribir" }')"
        end
      end
    end
  end

  def captcha
    if params['want']  == 'verify'
      if params['captcha'].slice(10,params['captcha'].length) == session['captchaCodes'][session['captchaAnswer']]
        render :json =>  {'status' => 'success'}
      else
        session['captchaCodes']=nil
        session['captchaAnswer']=nil
        render :json =>  {'status' => 'error'}
      end

    elsif params['want']  == 'refresh'
        captchaImages = [	{   	'label'	=> 'star',
          'on'		=> {	'top'		=> '-120px',
            'left'	=> '-3px'},
          'off'		=> {	'top'		=> '-120px',
            'left'	=> '-66px'},
        },
        { 	'label'	=> 'heart',
          'on'		=> {	'top'		=> '0',
            'left'	=> '-3px'},
          'off'		=> {	'top'		=> '0',
            'left'	=> '-66px'},
        },
        {	'label'	=> 'bwm',
          'on'		=> {	'top'		=> '-56px',
            'left'	=> '-3px'},
          'off'		=> {	'top'		=> '-56px',
            'left'	=> '-66px'},
        },
        {	'label'	=> 'diamond',
          'on'		=> {	'top'		=> '-185px',
            'left'	=> '-3px'},
          'off'		=> {	'top'		=> '-185px',
            'left'	=> '-66px'}
        } ]

      captchaCodes = {	'star'		=>   Digest::MD5.hexdigest(rand(99999999).to_s),
        'heart'		=> Digest::MD5.hexdigest(rand(99999999).to_s),
        'bwm' 		=> Digest::MD5.hexdigest(rand(99999999).to_s),
        'diamond' => Digest::MD5.hexdigest(rand(99999999).to_s)
      };

      captchaImages.shuffle!

      randomCaptcha = captchaImages.sample

      session['captchaAnswer']= randomCaptcha['label'];
      session['captchaCodes']= captchaCodes;

      #HTML output
      div =  '<div class="captchaWrapper" id="captchaWrapper">'
      count = 0
      captchaImages.each do |captchaImage|
        div += '	<a href="#" class="captchaRefresh"></a>
							<div	id="draggable_' + captchaCodes[captchaImage['label']] + '"
										class="draggable"
										style="left: ' + ((count * 68) + 15).to_s + 'px; background-position: ' + captchaImage['on']['top'] + ' ' + captchaImage['on']['left'] + ';"></div>'
        count+= 1
      end

      div += '<div class="targetWrapper">
                <div	class="target"	style="background-position: ' + randomCaptcha['off']['top'] + ' '  + randomCaptcha['off']['left'] + ';"></div>
						</div><input type="hidden" class="captchaAnswer" name="captcha" value="" />	</div>'
      render :text => div
    else
    end

  end

  def send_confirmation
    @user = User.find params[:id]
    @user.update_attributes params[:user]
    if @user.save
     @user.send_confirmation_instructions
    #@user = User.send_confirmation_instructions(params[:user])
      set_flash_message :notice, :send_instructions
      redirect_to :action => :edit
    else
      render :edit
    end

  end

end

