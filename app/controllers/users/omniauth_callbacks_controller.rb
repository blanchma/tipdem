# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    account = case request.env['omniauth.auth']['provider']
      when 'twitter' then
        Account::Twitter.from_omniauth(request.env['omniauth.auth'])
      when 'facebook' then
        Account::Facebook.from_omniauth(request.env['omniauth.auth'])
      when 'linkedin' then
        Account::LinkedIn.from_omniauth(request.env['omniauth.auth'])
      else
      logger.error "Omniauth Provider unknown(#{request.env['omniauth.auth']['provider']})"
      flash[:notice]="Something goes wrong. Try later, please."
    end

    if current_user
      account.user = current_user
      account.save
      redirect_to users_account_path
    elsif user = account.user
      sign_in_and_redirect(:user, user)
    else
      logger.info "Chain: #{session["chain"].inspect}, #{cookies["chain"].inspect}"
      user = User.create_from_omniauth(account)
      if chain = Chain.from_session(user,session["chain"] || cookies["chain"])
        sign_in(:user, user)
        logger.info "Chained and redirecting to campaign: #{chain.campaign.name}."
        redirect_to go_campaign_tips_path(chain.campaign_id)
      else
        sign_in_and_redirect(:user, user)
      end
    end
  end
  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :linkedin, :all

end

