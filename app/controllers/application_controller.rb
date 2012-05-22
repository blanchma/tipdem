# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  # # See ActionController::RequestForgeryProtection for details

  #before_filter :login_required
  # Scrub sensitive parameters from your log

  before_filter  :get_locale, :url_rewrite


  def url_rewrite
    logger.info "Rails.env is #{Rails.env}"
    unless (Rails.env == 'development')
      if ( request.host.include?('www') )
        redirect_to "#{APP_CONFIG['domain']}#{request.path}"
      end
    end
  end

  def confirm_user!
    unless user_signed_in? && current_user.confirmed?
      flash[:error]=:not_confirmed
      redirect_to "/my/profile"
    end
  end


  def is_admin?
    unless user_signed_in? && current_user.admin
      redirect_to :action => :login
    end
  end

  def set_timezone
    time_zone = params[:time_zone]
    time_zone = time_zone.split("/").last
    time_zone["_"]=" "
    current_user.time_zone = time_zone
    current_user.dst = params[:daylight]
    logger.info "Time zone from user #{current_user.email} to #{time_zone}"
    Time.zone = current_user.time_zone
    render :text => current_user.save
  end

  def get_locale
    logger.info "Cookie locale is setted to: #{cookies[:locale]}"
    if cookies[:locale]
      logger.debug "* Cookie locale: #{cookies[:locale]}"
      set_locale cookies[:locale]
      #cookies[:locale] = {:value => user.id.to_s, :expires => 1.years.from_now }
    elsif  user_signed_in?
      logger.debug "* user locale: #{current_user.locale}"
      set_locale current_user.locale

    elsif !extract_locale_from_accept_language_header.nil?
      logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
      set_locale extract_locale_from_accept_language_header
      logger.debug "* Locale set to '#{I18n.locale}'"
    end
  end

  def restart
    if params[:token] == "gauchogaucho1917"
      system "/usr/bin/rake Rails.env=#{Rails.env} db:migrate >> #{Rails.root}/log/rake.log &"
      system 'touch tmp/restart.txt'
      head :ok
    else
      head "404"
    end
  end


  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first unless request.env['HTTP_ACCEPT_LANGUAGE'].nil?
  end

  def set_locale(locale)
    locale = locale.downcase if locale
    #TODO Add a condition
    cookies[:locale]= locale
    session[:locale]= locale
    I18n.locale = locale
  end



  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    logger.info "Logout Extended... Cleaning session data"
    flash[:notice]=nil
    session[:campaign_id]=nil
    session[:fisher]=nil
    root_path
  end


  def after_sign_in_path_for(resource)
    stored_location_for(resource) || user_root_path
  end





  protected
  def set_flash_message(key, kind, now=false)
    flash_hash = now ? flash.now : flash
    flash_hash[key] = I18n.t(:"#{:user}.#{kind}",
      :scope => [:devise, controller_name.to_sym], :default => kind)
  end


end

#TODO Para customizar paginas de error
#http://stackoverflow.com/questions/943138/how-does-one-implement-dynamic-404-500-etc-error-pages-in-rails
#http://stackoverflow.com/questions/2238244/custom-error-pages-in-rails

