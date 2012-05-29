# -*- encoding : utf-8 -*-
require 'google_chart'

class CampaignsController < ApplicationController
  layout 'panel'
  before_filter :authenticate_user!
  before_filter :confirm_user!, :except => [:show, :info]


  def show

  end

  def pay
    campaign_id = params[:id] || params[:campaign_id]
    @campaign = Campaign.find campaign_id
  end

  def info
    @campaign = Campaign.find params[:id]
    render :layout => false
  end

  def edit
    @campaign = Campaign.find params[:id]
  end

  def destroy
    @campaign = Campaign.find params[:id]

    if @campaign.user_id == current_user.id || current_user.admin
      logger.info "Campaign #{@campaign.id} destroyed by: #{current_user.email}"
      @campaign.destroy
      render :text => true
    else
      render :text => false
    end
  end

  def index_inactives
    @non_active_campaigns = current_user.owned_campaigns.non_active
  end

  def index_actives
    @active_campaigns = current_user.owned_campaigns.active(:include => [:chains, :landing_page_hits])
  end

  def google_line_chart
    @test = GoogleChart.annotated_time_line(params[:campaign_id])
    render :json => @test
  end

  def google_pie_gender_chart
    @test = GoogleChart.image_pie_chart_gender(params[:campaign_id])
    render :json => @test
  end

  def google_pie_click_referer_chart
    @test = GoogleChart.image_pie_chart_click_referer(params[:campaign_id])
    render :json => @test
  end

  def google_pie_hit_referer_chart
    @test = GoogleChart.image_pie_chart_hit_referer(params[:campaign_id])
    render :json => @test
  end


  def index

  end

  def update
    @campaign = Campaign.find params[:id]
    @campaign.update_attributes(params[:campaign])

    logger.info "Logo URL: #{params[:campaign][:logo_url]}"
    unless params[:campaign][:logo_url].empty?
      begin
        @campaign.logo = URLTempfile.new(params[:campaign][:logo_url])
      rescue Exception => e
        logger.error "URLTempfile Error: #{e.message}"
        @campaign.errors.add("url_tempfile", "La URL introducida no es válida")
      end
    end
    @campaign.save_without_validation

    respond_to do |format|
      if @campaign.valid?
        format.html { redirect_to(:my_campaigns, :notice => 'Los datos de la campaña fueron actualizados.') }
      else
        format.html { render :action => "edit", :layout => 'panel' }
      end
    end

  end

  def expand
  end


  def new

    campaign_id = params[:id] || params[:campaign_id]
    if campaign_id
      @campaign = Campaign.find campaign_id
    else
      @campaign = Campaign.new
    end
  end


  def create
    logger.info "Tipo de campaña: #{params[:campaign][:mode]}"
    campaign_id = params[:id] || params[:campaign_id]
    if campaign_id
      @campaign = Campaign.find campaign_id
      @campaign.update_attributes(params[:campaign])
    else
      @campaign = Campaign.new(params[:campaign])
      @campaign.status = CampaignStatus::Incomplete
    end

    @campaign.owner = current_user

    logger.info "Logo URL: #{params[:campaign][:logo_url]}"
    unless params[:campaign][:logo_url].empty?
      begin
        @campaign.logo = URLTempfile.new(params[:campaign][:logo_url])
      rescue Exception => e
        logger.error "URLTempfile Error: #{e.message}"
        @campaign.errors.add("url_tempfile", "La URL introducida no es válida")
      end
    end
    @campaign.name='test' if params[:campaign][:name].empty?
    @campaign.save_without_validation
    #session[:campaign_id]=@campaign.id



    if @campaign.valid?
      flash[:notice]=nil
      flash[:error]=nil
      if params[:save_and_next] == 'yes'
        session[:campaign_id]=@campaign.id
        redirect_to step_categories_path(:campaign_id => @campaign.id)
      else
        @campaign.name=nil if params[:campaign][:name].empty?
        render :action => :new
        return
      end
    else
      @campaign.name=nil if params[:campaign][:name].empty?
      render :action => :new
    end
  end


  def success
    @campaign = Campaign.find_by_id params[:id]
    logger.info "Campaign: #{@campaign.id} (#{@campaign.name}) fue abonada. Request: #{request.url}"

    @campaign.update_attribute(:status, CampaignStatus::WaitingApproval)
    #CampaignStatusMailer.delay.deliver_paid_email(@campaign, request.url)
    Payment.create(:user_id => @campaign.user_id, :campaign_id => @campaign.id, :additional_data => request.url)

  end

  def fail
    @campaign = Campaign.find_by_id params[:id]
    logger.info "Campaign: #{@campaign.id} (#{@campaign.name}) fallo en el pago. Request: #{request.url}"
  end

  def activate
    @campaign = Campaign.find_by_id params[:id]
    if @campaign.status != CampaignStatus::Active
      @campaign.activate!
      @campaign.save
      CampaignStatusMailer.delay.deliver_approval_email @campaign
    end
    render :text => @campaign.status
  end

  def disapprove
    @campaign = Campaign.find_by_id params[:id]
    if @campaign.status != CampaignStatus::NotApproved
      @campaign.disapprove!
      @campaign.save
      CampaignStatusMailer.delay.deliver_disapproval_email(@campaign, params[:message])
    end
    render :text => @campaign.status
  end

  def detailed
    @campaign = Campaign.find params[:id]
  end

end
