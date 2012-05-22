# -*- encoding : utf-8 -*-
class PostsController < ApplicationController
  layout 'panel'
  helper_method :last_post_message, :publish_daily?
  
  before_filter :authenticate_user!, :back, :find_campaign
  
  rescue_from ActiveRecord::RecordNotFound, :with => :post_not_found

  def post_not_found
    flash[:error]="Ese post ya no existe"
    respond_to do |format|
      format.html { redirect_to :action => :index}
      format.js do
        render :update do |page|
          page.redirect_to :action => :index, :campaign_id => @campaign.id
        end
      end
    end
    
  end

  
  def go
    if current_user.posts.not_failed.count(:conditions => {:campaign_id => @campaign.id}) > 0 
      redirect_to :action => :index, :campaign_id => @campaign.id
    else
      redirect_to :action => :new, :campaign_id => @campaign.id
    end
  end

  def index
    @posts = current_user.posts.not_failed.all(:conditions => {:campaign_id => @campaign.id})
  end

  def last_post_message(channel)
    post = current_user.posts.last(:conditions => {:campaign_id => @campaign.id, :channel => channel})
    post.message if post
  end

  def publish_daily?(channel=nil)
    Post.publish_daily?(current_user, @campaign, channel)
  end

  def new
    @post = current_user.posts.new(:campaign => @campaign)
    index
  end

  def edit
    @post = Post.find params[:id]
    @campaign ||=  @post.campaign

    respond_to do |format|
      format.html
      format.js do
        render :update do |page|
          page.replace_html "form_#{@post.channel}", :partial => "form", :locals => { :post => @post, :channel => @post.channel }
          page.visual_effect :highlight , "form_#{@post.channel}"
        end
      end
    end

  end


  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if  @post.update_attributes(params[:post])
        format.html { redirect_to :action => :new, :campaign_id => @campaign.id }
        format.js do
          render :update do |page|
            page.replace_html "errors_#{@post.channel}", ""
            page.replace_html "form_#{@post.channel}", :partial => "post", :locals => { :post => @post }
            page.visual_effect :highlight , "post_#{@post.id}"
          end
        end

      else
       
        post_errors = @post.errors.full_messages.join('<br/>')
        logger.info "@post errors= #{post_errors}"
       
        format.html { render :action => :new }
        format.js do
          render :update do |page|
            page.replace_html "errors_#{@post.channel}", ""
            post_errors.each do |error|
              page.insert_html :bottom, "errors_#{@post.channel}", error
            end
          end
        end

      end
    end
  end

  def create
    @post = current_user.posts.build params[:post]
        
    respond_to do |format|
      if @post.save
        
        format.html { redirect_to :action => :new, :campaign_id => @campaign.id }
        format.js do
          render :update do |page|
            page.replace_html "errors_#{@post.channel}", ""
            page.replace_html "form_#{@post.channel}", :partial => "post", :locals => { :post => @post }
            page.visual_effect :highlight , "post_#{@post.id}"
          end
        end
          
      else
        post_errors = @post.errors.full_messages.join('<br/>')
        logger.info "@post errors= #{post_errors}"
        format.html { render :action => :new }
        format.js do
          render :update do |page|
            page.replace_html "errors_#{@post.channel}", ""
            post_errors.each do |error|
              page.insert_html :bottom, "errors_#{@post.channel}", error
            end
            page.visual_effect :highlight, "errors_#{@post.channel}"
          end
        end
     
      end
    end

  end

  def destroy
    @post =  current_user.posts.find_by_id(params[:id])

    respond_to do |format|
      if @post.nil? || @post.destroy
        format.html do
          flash[:notice]="Publicación cancelada."
          redirect_to :action => :index, :campaign_id => @campaign.id
        end
      end
      format.js do
        render :update do |page|
          if params[:remove]
            page.remove "post_#{@post.id}"
          else
            page.replace_html "form_#{@post.channel}", :partial => "form", :locals => { :post => @post, :channel => @post.channel }
            page.insert_html :bottom, "errors_#{@post.channel}", "Cancelado con éxito."
            page.visual_effect :highlight , "form_#{@post.channel}"
          end
            
        end
      end
    end
  end



  def stop
    @posts = current_user.posts(:conditions => {:campaign => @campaign, :channel => params[:channel]})
    @posts.each do |post|
      post.stop!
    end
    render :text => true
  end


  private

  def find_campaign
    logger.info "Find campaign #{params[:campaign_id]} for budget"
    if params[:campaign_id]
      @campaign = Campaign.find params[:campaign_id]
    end
  end

  def back
    logger.info "[PostsController] Return to: #{request.referer}"
    if request.referer.include?"promotion"
      session[:return] = ["Mis Promociones", request.referer]
    elsif request.referer.include? "panel"
      session[:return] = ["Inicio", request.referer]
    else
      
    end
  end

end
