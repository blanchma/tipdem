module Concern
  module Authorization
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
  end
end
