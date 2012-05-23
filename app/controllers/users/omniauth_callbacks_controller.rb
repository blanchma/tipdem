# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    create
  end

  def twitter
    create
  end

  def linked_in
    create
  end

  def create
    omniauth = request.env["omniauth.auth"]
    @authentication = Authentication.find_by_provider_and_uid(omniauth["provider"], omniauth["uid"] )

    if @authentication && current_user

      flash[:alert]= t("accounts.linked")
      current_user.authentications << @authentication
      redirect_to my_accounts_path

    elsif @authentication && @authentication.user
      @authentication.token = omniauth["credentials"]["token"]
      @authentication.secret = omniauth["credentials"]["secret"] if omniauth["secret"]
      @authentication.save

      set_flash_message :notice, :signed_in
      sign_in_and_redirect(:user, @authentication.user)

    elsif current_user #agregar nuevas cuentas
      current_user.apply_omniauth(omniauth)
      current_user.save
      Resque.enqueue(CountFriendsJob.new(current_user))
      flash[:notice]="Cuenta de #{t omniauth["provider"]} vinculada exitosamente"
      redirect_to my_accounts_path
    else
      #Paranoic mode
      @user = User.new
      if @authentication
         @user.authentications << @authentication
      else
         @authentication = @user.apply_omniauth(omniauth)
      end


      logger.info "User => #{@user.email}"

      if @user.save
        flash[:"#{:user}_signed_up"] = true
        @user.chain!(session["click"] ||cookies["click"])
        set_flash_message :notice, :signed_up
        #ContactMailer.welcome_email(@user).deliver

        if @user.chained?
          sign_in(:user, @user)
          redirect_to go_campaign_tips_path(@user.chain.campaign_id)
        else
          sign_in_and_redirect(:user, @user)
        end

      else
        session[:omniauth]=request.env["omniauth.auth"]
        render :action => :ask_confirmation
        return
      end
    end
  end

end

