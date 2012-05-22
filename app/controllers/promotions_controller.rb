# -*- encoding : utf-8 -*-
class PromotionsController < ApplicationController

  before_filter :authenticate_user!

  def index
    #@promotions  = current_user.promotions.page :page => params[:page]
    @promotions  = current_user.promotions.not_owned.page :per_page => 10, :page => params[:page]
    render :layout => 'panel'
  end

  def show
    @promotion= Promotion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @promotion}
    end
  end

  def new
    @campaign = Campaign.find params[:campaign_id]
  end




  def mini
    render :action => :campaign_details
  end
end

