# -*- encoding : utf-8 -*-
class CategoriesController < ApplicationController
  before_filter :find_categorizable
  layout 'panel'
  #layout :set_layout

  def edit
    @categories = Category.all(:order => "name")
    if @user
      render :action => :user_edit
    else
      render :action => :campaign_edit
    end
  end

  def update
    @categories = Category.all
    @categorizable.category_ids=params[:categories] if params[:categories]

    if @user
      flash[:notice]="Sus Preferencias han sido actualizadas."
      render :action => :user_edit
    elsif @campaign
      if @campaign.categories.count > 0 && @campaign.categories.count < 4
        flash[:notice]=nil
        flash[:error]=nil
        if params[:save_and_next] == 'yes'
          session[:campaign_id]=@campaign.id
          redirect_to step_rewards_path(:campaign_id => @campaign.id)
        else
          render :action => :campaign_edit
          return
        end
      else
        @campaign.errors.add(:base, "La campaña tiene que tener mínimo una categoría y máximo tres.")
        render :action => :campaign_edit
      end
    else
      #Impossible path
    end

  end

  private

  def find_categorizable
    if params[:user_id]
      @categorizable = User.find params[:user_id]
      @user = @categorizable
    elsif params[:campaign_id]
      @categorizable = Campaign::Base.find params[:campaign_id]
      @campaign = @categorizable
    else
      logger.error "Categorizable class not found"
    end
  end

  def set_layout
    params[:layout] || "panel"
  end


end
