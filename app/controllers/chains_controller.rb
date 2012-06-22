# -*- encoding : utf-8 -*-
class ChainsController < ApplicationController

  def create
    if session["click"]
      campaign_id = session["click"]["campaign"]
      user_id = session["click"]["user"]
      channel = session["click"]["channel"]
      #cookies["click"].

      unless current_user.chained || user_id.nil?
        @chain = Chain.create(:campaign_id => campaign_id, :fisher_id => user_id,
          :fish_id => current_user.id, :channel => channel)
        logger.info "#{current_user.email} chained(#{@chain.id}) to #{user_id}"

        redirect_to :action => :promote_now
      else
        redirect_to user_root_path
      end
    else
      logger.info "Already exist a chain for this user to this campaign"
      redirect_to user_root_path
    end
  end

end
