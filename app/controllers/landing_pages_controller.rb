# -*- encoding : utf-8 -*-
class LandingPagesController < ApplicationController
  layout 'panel'

  #En el futuro usar request.referer en vez de channel, para averiguar la procedencia
  before_filter :find_campaign, :only => [:edit, :update, :new, :create]

  before_filter :check_url, :only => ['show']

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
    elsif @landing_page.main_image_source  == ImageSource::Logo
      @landing_page.main_image_url=nil
    else      
      @landing_page.main_image_url=nil
    end

    @landing_page.save(false)

    if @landing_page.valid?
      logger.info "Landing Page Datos guardados."
      if params[:save_and_next] == 'yes'
        @campaign.completed!
        @campaign.save
        redirect_to step_pay_path(:campaign_id => @campaign.id)
      else
        render :action => :new
        return
      end
    else      
      render :action => :new
      return
    end
  end

  def edit        
    @landing_page = @campaign.landing_page
    render :layout => 'panel'
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
    if params[:main_image_source] == 3
      @landing_page.main_image = @campaign.logo
    end

    @landing_page.save_without_validation if @landing_page.changed?

    respond_to do |format|
      if @landing_page.valid?
        flash[:notice]='La Página Promocional fue actualizada'
        format.html { redirect_to(:action => "edit", :layout => 'panel') }
      else
        @campaign = @landing_page.campaign
        format.html { render :action => "edit", :layout => 'panel' }
      end
    end
  end


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

  

  def check_url    
    logger.info "User-Agent: #{request.user_agent}"
    logger.info "User-Agent HEADER: #{request.env["HTTP_USER_AGENT"]} "
    if params[:link]
      params[:link].each do |value|
        @channel = value if Channel.all.include? value
        @user = User.find_by_id value unless @user
      end      
    end

    logger.info "Campaign: #{params[:campaign]}"
    logger.info "User #{@user ? @user.id : "not found"}"
    logger.info "Channel #{@channel ? @channel : "not found" }"
    
    begin
      @campaign = Campaign.find params[:campaign]      
      return if params[:test]
    rescue      
      logger.info "Campaign with id=#{params[:campaign]} doesnt exist"
      raise ActionController::RoutingError.new('Not Found')
    end

    if @campaign.visitable?
      if @user && @channel
        cookies["click_#{@campaign.id}"]={:value => "#{@campaign.id},#{@user ? @user.id : nil},#{@channel}", :expire => 1.year.from_now}
        session["click"]={"campaign" => @campaign.id, "user" => @user ? @user.id : nil, "channel" => @channel}
      end    
      create_landing_page_hit
      logger.info "Session campaign id= #{@campaign.id}"
    else
      redirect_to inactive_landing_page_path(:id => params[:campaign])
    end
      
  end

  def inactive
    render :layout => 'landing_pages'
  end

  def client_page
    @landing_page = LandingPage.find params[:id]
    campaign_id =  @landing_page.campaign_id
      
    unless request.cookies.include? "hit_#{campaign_id }"
    

      if session["click"]["campaign_id"]  == campaign_id
        user_id = session["click"]["user"]
        channel = session["click"]["channel"]

      elsif request.cookies.include?"click_#{campaign_id }"
        user_id = cookies["click_#{campaign_id }"][0]
        channel = cookies["click_#{campaign_id }"][1]    
      else
        user_id = nil
        channel = Channel::Default
      end

      clientpage_hit = ClientPageHit.new(
        :fisher_id => user_id,
        :channel => channel,
        :campaign_id => campaign_id,
        :url => @landing_page.owner_url,
        :user_agent => request.user_agent || request.env["HTTP_USER_AGENT"],
        :ip => request.remote_ip
      )
      saved = clientpage_hit.save
      cookies["hit_#{campaign_id }"]={:value => true, :expire => 1.year.from_now} if saved
    end
    
    redirect_to @landing_page.owner_url
  end


  def create_landing_page_hit    
    unless request.cookies.include? "click_#{@campaign.id}"
     
      lhit = LandingPageHit.new(
        :fisher_id => (@user ? @user.id : nil),
        :channel => (@channel ? @channel : Channel::Default),
        :campaign_id => @campaign.id,
        :ip => request.remote_ip,
        :referrer => request.referrer,
        :user_agent => request.user_agent || request.env["HTTP_USER_AGENT"])
      saved = lhit.save
      logger.info "LandingPage Hit saved: #{saved}"
      if saved
        cookies["click_#{@campaign.id}"]={:value => [lhit.fisher_id, lhit.channel, lhit.campaign_id ], :expire => 1.year.from_now}
      end
    end

  end

  private
  def find_campaign
    @campaign = Campaign.find params[:campaign_id]
  end

end
