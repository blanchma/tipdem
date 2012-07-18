# -*- encoding : utf-8 -*-
class PanelController < ApplicationController

  before_filter :authenticate_user!, :panel_notice

  def panel_notice
    #@panel_notice = PanelNotice.last
  end

  def home
    @earnings = current_user.promotions.sum(:current_money)
    @campaigns = Campaign::Base.active(:include => :budget).order("created_at DESC")
    if params[:status]
      @campaigns = Campaign::Base.active.where("status = ?", params[:status]).includes(:budget).page(params[:page]).per(4).order('created_at DESC')
    else
      @campaigns = Campaign::Base.active.includes(:budget).page(params[:page]).per(4).order('created_at DESC')
    end
  end

  def pay_to_promotor
    Delayed::Job.enqueue(PaymentJob.new(params[:user] , params[:payment]))
    promotion = Promotion.find_by_id(params[:promote_id])
    promotion.current_money = 0.0
    promotion.save
    render :layout => params[:layout]
  end

  def promote_fisher_campaign
    @campaign = current_user.chain ? current_user.chain.campaign : nil
    unless @campaign
      redirect_to user_root_path
    else
      @post_form = PostForm.find_or_create_by_user_id_and_campaign_id current_user.id, @campaign.id
      @post_form.message = @campaign.default_message unless @post_form.message
    end
  end

  def promote_campaign
    @campaign = Campaign::Base.find_by_id params[:id]
    unless @campaign
      redirect_to user_root_path
    else
      @post_form = PostForm.find_or_create_by_user_id_and_campaign_id current_user.id, @campaign.id
      @post_form.message = @campaign.default_message unless @post_form.message
    end
  end

  def accounts
  end

end
