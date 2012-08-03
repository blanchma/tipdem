class RewardsController < ApplicationController
  before_filter :check_authorization!

  def new
    @rewards = @campaign.rewards
  end

  def create
    @rewards = @campaign.rewards
    @rewards.update_attributes params[:rewards]

    if @rewards.save
      flash[:notice]=nil
      flash[:error]=nil
      if params[:save_and_next] == 'yes'
        redirect_to step_landing_path(:campaign_id => @campaign.id)
      else
        render :action => :new
        return
      end
    else
      flash[:notice]= "Debe elegir al menos una modalidad de campaña"
      render :action => :new
    end
  end

  def edit
  end

  def update
  end


  private

  def find_campaign
    begin
      logger.info "Find campaign #{params[:campaign_id]} for rewards"
      @campaign = Campaign::Base.find params[:campaign_id]
    rescue
      redirect_to user_root_path, :notice => "Try again later!" unless @campaign
    end
  end


end
