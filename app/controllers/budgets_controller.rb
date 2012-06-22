class BudgetsController < ApplicationController
  layout 'panel'

  before_filter :authenticate_user!
  before_filter :find_campaign

  def new
    @budget = @campaign.budget || @campaign.build_budget
  end

  def create
    @budget = @campaign.budget || @campaign.build_budget
    @budget.update_attributes params[:budget]

    if @budget.save
      flash[:notice]=nil
      flash[:error]=nil
      if params[:save_and_next] == 'yes'
        redirect_to step_landing_path(:campaign_id => @campaign.id)
      else
        render :action => :new
        return
      end
    else
      #flash[:notice]= "Debe elegir al menos una modalidad de campaña"
      render :action => :new
    end
  end

  def edit
  end

  def update
  end

  def pay
    @budget = @campaign.budget
  end

  private

  def find_campaign
    begin
      logger.info "Find campaign #{params[:campaign_id]} for budget"
      @campaign = Campaign::Base.find params[:campaign_id]
    rescue
      redirect_to user_root_path, :notice => "Try again later!" unless @campaign
    end
  end

end
