# -*- encoding : utf-8 -*-
require 'google_chart'

class CampaignsController < ApplicationController
  layout 'panel'
  before_filter :authenticate_user!
  before_filter :confirm_user!, :except => [:show, :info]
  before_filter :find_campaign
  before_filter :check_authorization!, :only => [:create, :update]

  def show
  end

  def new
    @campaign ||= Campaign::Base.new
  end

  def create
    logger.info "Tipo de campaña: #{params[:campaign][:mode]}"
    campaign_id = params[:id] || params[:campaign_id]
    if campaign_id
      @campaign = Campaign::Base.find campaign_id
      @campaign.update_attributes(params[:campaign])
    else
      @campaign = Campaign::Base.new(params[:campaign])
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

    if @campaign.save
      if params[:save_and_next] == 'yes'
        session[:campaign_id]=@campaign.id
        redirect_to step_categories_path(:campaign_id => @campaign.id)
      else
        render :action => :new
      end
    else
      render :action => :new
    end
  end

  def pay
  end

  def info
    render :layout => false
  end

  def edit
  end

  def destroy
    logger.debug "Campaign #{@campaign.id} destroyed by: #{current_user.email}"
    @campaign.destroy
    render :text => true
  end

  def update
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


    respond_to do |format|
      if @campaign.save
        format.html { redirect_to(:my_campaigns, :notice => 'Los datos de la campaña fueron actualizados.') }
      else
        format.html { render :action => "edit", :layout => 'panel' }
      end
    end

  end

  def expand
  end

  def success
    logger.info "Campaign: #{@campaign.id} (#{@campaign.name}) was payed. Request: #{request.url}"
    @campaign.paid!
    #CampaignStatusMailer.delay.deliver_paid_email(@campaign, request.url)
    Payment.create(:user_id => @campaign.user_id, :campaign_id => @campaign.id, :additional_data => request.url)
  end

  def fail
    logger.info "Campaign: #{@campaign.id} (#{@campaign.name}) payment fail. Request: #{request.url}"
  end

  def activate
    @campaign.approve!
    @campaign.save
    render :text => @campaign.status
  end

  def disapprove
    @campaign.dissaprove!
    @campaign.save
    render :text => @campaign.status
  end

  def detailed
    @campaign = Campaign::Base.find params[:id]
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

  private

  def find_campaign
    #if params[:campaign_id] || params[:id]
      campaign_id = params[:campaign_id] || params[:id]
      @campaign = Campaign::Base.find_by_id campaign_id
    #end
  end



end
