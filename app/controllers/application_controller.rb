# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all
  before_filter :get_locale, :url_rewrite

  def check_authorization!
    if user_signed_in? && @campaign && !@campaign.authorized?(current_user)
      flash[:error]=:not_authorized
      redirect_to user_root_path
    end
  end

  def confirm_user!
    unless user_signed_in? && current_user.confirmed?
      flash[:error]=:not_confirmed
      redirect_to user_root_path
    end
  end

  def is_admin?
    unless user_signed_in? && current_user.admin?
      redirect_to :action => :login
    end
  end

  def authenticate_admin_user!
    render_403 and return if user_signed_in? && !current_user.admin?
    authenticate_user!
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end


  def url_rewrite
    unless (Rails.env == 'development')
      if ( request.host.include?('www') )
        redirect_to "#{APP_CONFIG['domain']}#{request.path}"
      end
    end
  end

  def get_locale
    logger.info "Cookie locale is setted to: #{cookies[:locale]}"
    if cookies[:locale] || session[:locale]
      logger.debug "* Cookie locale: #{cookies[:locale]}"
      set_locale cookies[:locale] || session[:locale]
      #cookies[:locale] = {:value => user.id.to_s, :expires => 1.years.from_now }
    elsif  user_signed_in?
      logger.debug "* User locale: #{current_user.locale}"
      set_locale current_user.locale
    elsif !extract_locale_from_accept_language_header.nil?
      logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
      set_locale extract_locale_from_accept_language_header
    end
    logger.debug "* Locale set to '#{I18n.locale}'"
  end

  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first unless request.env['HTTP_ACCEPT_LANGUAGE'].nil?
  end

  def set_locale(locale)
    locale.downcase!
    session[:locale] = locale
    cookies[:locale] = locale
    I18n.locale = locale
  end

  protected

  def after_sign_out_path_for(resource_or_scope)
    logger.info "Logout Extended... Cleaning session data"
    flash[:notice]=nil
    session[:campaign_id]=nil
    root_path
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || user_root_path
  end


end

#TODO Para customizar paginas de error
#http://stackoverflow.com/questions/943138/how-does-one-implement-dynamic-404-500-etc-error-pages-in-rails
#http://stackoverflow.com/questions/2238244/custom-error-pages-in-rails