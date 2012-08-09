# -*- encoding : utf-8 -*-
class LandingPagesController < ApplicationController
  layout 'panel'
  before_filter :find_campaign, :only => [:edit, :update, :new, :create]

  before_filter :spam_filter, :only => [:show]
  before_filter :retrieve_data, :only => [:show]

  respond_to :html, :js

  def new
    @landing_page = @campaign.landing_page || @campaign.build_landing_page
    @landing_page.main_image_source = "3" if @landing_page.main_image_logo?
  end

  def create
    @landing_page = @campaign.landing_page || @campaign.build_landing_page
    @landing_page.update_attributes(params[:landing_page])

    @landing_page.main_image_source = params[:landing_page][:main_image_source]

    if  @landing_page.main_image_source  == ImageSource::URL && params[:landing_page][:main_image_url]
      begin
        @landing_page.main_image_url = params[:landing_page][:main_image_url]
        @landing_page.main_image = URLTempfile.new(params[:landing_page][:main_image_url])
      rescue Exception => e
        @landing_page.main_image.clear
        logger.error "URLTempfile Error: #{e.message}"
      end
    else
      @landing_page.main_image_url=nil
    end

    if @landing_page.save
      logger.info "Landing Page Datos guardados."
      if params[:save_and_next] == 'yes'
        @campaign.completed!
        @campaign.save
        redirect_to step_pay_path(:campaign_id => @campaign.id)
      else
        render :new
      end
    else
      render :new
    end
  end

  def edit
    @landing_page = @campaign.landing_page
  end

  def update
    @landing_page = @campaign.landing_page
    @landing_page.update_attributes(params[:landing_page])

    unless params[:landing_page][:main_image_url].empty?
      begin
        @landing_page.main_image = URLTempfile.new(params[:landing_page][:main_image_url])
      rescue Exception => e
        logger.error "URLTempfile Error: #{e.message}"
        #@landing_page.errors.add("url_tempfile", "La URL introducida no es valida")
      end
    end
    @landing_page.main_image = @campaign.logo if params[:main_image_source] == 3
    @landing_page.save_without_validation if @landing_page.changed?

    if @landing_page.valid?
      flash[:notice]='La Página Promocional fue actualizada'
      render "edit"
    else
      @campaign = @landing_page.campaign
      format.html { render "edit"}
    end

  end


  ### Public Landing Page ###
  def show
    @landing_page = @campaign.landing_page
    if @landing_page.owner_url && !@landing_page.owner_url.empty?
      @client_url = url_for :action => :client_page, :campaign_id => @campaign.id, :client_url => @landing_page.owner_url
      @target = "_blank"
    else
      @client_url = "#"
      @target=""
    end
    render :layout => "landing_pages"
  end



  def spam_filter
    user_agent = request.user_agent || request.env["HTTP_USER_AGENT"]
    logger.info "User-Agent: #{}"
    logger.info "User-Agent HEADER: #{request.env["HTTP_USER_AGENT"]} "
    unless AntiSpamService.human?(user_agent)
      #raise ActionController::RoutingError.new('Sorry, your a bot')
    end
  end

  def retrieve_data
    #Find campaign
    @campaign = Campaign::Base.find params[:id]
    params[:id] = @campaign.id

    #Check visitable before process hit and cookie control
    if @campaign.visitable?
      params[:user_id] = nil unless User.exists?(params[:user_id])
      @channel = params[:channel] if Channel.all.include? params[:channel]

      if LandingPageHit.create_from_request(request)
        cookies["click_#{@campaign.id}"] = {
          :value => [@campaign.id, params[:user_id], params[:channel]],
          :path => request.path,
          :expire => 1.year.from_now
        }
      end

      if params[:user_id]
        chain = {
          :campaign_id => @campaign.id,
          :user_id => params[:user_id],
          :channel => @channel,
          :referrer => request.referrer
        }
        session["chain"] = chain
        cookies.permanent["chain"]= chain
      end
    else
      redirect_to root_path, :notice => t("landing_page.inactive")
    end

    rescue ActiveRecord::RecordNotFound => e
     redirect_to root_path, :notice => t("landing_page.not_found")
  end

  private
  def find_campaign
    @campaign = Campaign::Base.find params[:campaign_id]
  end

end
