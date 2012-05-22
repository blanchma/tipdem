# -*- encoding : utf-8 -*-
class PanelController < ApplicationController

  before_filter :authenticate_user!, :panel_notice


  def panel_notice
    @panel_notice = PanelNotice.last
  end


  def home
    @earnings = current_user.promotions.sum(:current_money)
    @campaigns = Campaign.active(:include => :budget).order("created_at DESC")
    if params[:status]
      @campaigns = Campaign.active.where("status = ?", params[:status]).includes(:budget).page(params[:page]).per(4).order('created_at DESC')

    else
      @campaigns = Campaign.active.includes(:budget).page(params[:page]).per(4).order('created_at DESC')
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
    @campaign = Campaign.find_by_id params[:id]
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

=begin
  def add_to_cart
    product_id = params[:product_id]
    logger.debug "product_id= #{product_id}"
    logger.debug "campaign_id #{session[:campaign_id]}"
    logger.debug "quantity  #{params[:quantity]}"
    logger.debug "number #{params[:number]}"
    logger.debug "cost #{params[:cost]}"
    logger.debug "name #{params[:name]}"


    if session[:cart] != nil
      if session[:cart].include?(product_id)
        render :update do |page|
          page.set_product_message(product_id, "Ya se agrego")
        end
        return
      end
    else
      session[:cart] = {}
    end

    session[:cart][product_id]={ :name => params[:name], :quantity => params[:quantity], :number => params[:number], :cost => params[:cost] }

    render :update do |page|
      page.set_product_message(product_id, "Se agrego con éxito")
      page.replace_html('cart_list', :partial =>'cart_display', :locals => {:products => session[:cart]} )
    end

  end

  def remove_from_cart
    product_id = params[:product_id]
    logger.debug "product_id " ,  product_id
    logger.debug "campaign_id " ,  session[:campaign_id]

    if session[:cart] != nil && session[:cart].include?(product_id)
      session[:cart].delete(product_id)

      #point_campaign = PointCampaign.find(session[:campaign_id])
      #reward = point_campaign.rewards.first(:conditions => {:product_award_id => product_id})
      #reward.destroy unless reward.nil?
      render :update do |page|
        page.set_product_message(product_id, "Removido")
        page.replace_html('cart_list', :partial =>'cart_display', :locals => {:products => session[:cart]} )
      end
      return
    else
      logger.debug("Producto: #{product_id} no fue encontrado")
      render :update do |page|
        page.set_product_message(product_id, "Este producto no fue agregado")
      end
      return
    end

  end


  def third_step_create_campaign
    @products = ProductAward.find(:all)
    @cart = session[:cart]
  end



  def submit_third_step
    #TODO: Adaptar esto a otras modalidades
    #Esta parte esta hardcodeada para PointCampaign, OJO!
    point_campaign = Campaign.find(session[:campaign_id]).reference

    if session[:cart].nil? || session[:cart].empty?
      flash[:error]="Debe elegir al menos un producto"
      flash[:notice]=nil
      flash[:error]=nil
      redirect_to :action => :third_step_create_campaign
      return
    else
      session[:cart].each do |key, value|
        reward = Reward.new
        reward.point_campaign_id = session[:campaign_id]
        reward.award_id = key
        reward.points = value[:number]
        reward.quantity = value[:quantity]
        reward.save
      end

    end
    redirect_to :action => :fourth_step_create_campaign
  end

def publish_twitter
    auth = Authentication.find_by_user_id_and_provider(current_user.id, 'twitter')
    if auth.nil?
      @message="Something goes wrong"
      logger.info "Auth to Twitter is nil"
    elsif auth
      token = auth.token
      secret = auth.secret
      @campaign = Campaign.find_by_id session[:campaign_id]
      if @campaign
        begin
          twitter = TwitterWrapper.new
          client = twitter.get_twitter(token, secret)
          url = BITLY.shorten current_user.link_for_twitter(@campaign)
          resp = client.update("#{params[:message]} #{url.short_url}")
          #resp = client.update("Probando desde tipdem")
          logger.info "Resp Twitter = #{resp}"
          @message="Successfully published"
        rescue Exception => e
          logger.error e
          if e.message.include?"Status is a duplicate"
            @message="Your can't publish the same tweet."
          else
            @message="An error happen. Try later, please."
          end
        end
      else
        @message="You must choose a campaign first"
      end
    else
      logger.info "No se autentico con Twitter"
      @message="An error happen during authentication through Twitter. Try later, please."
    end
    logger.info "Message=#{@message}"
    render :inline => @message

  end

  def publish_facebook
    auth = Authentication.find_by_user_id_and_provider(current_user.id, 'facebook')
    logger.info "auth is nil?#{auth.nil?}"
    if auth.nil?
      #render :update do |page| page << "window.location.href= '/login/with/facebook'" end
      @message="Something goes wrong"
      logger.info "Auth to Facebook is nil"
    elsif auth
      token =  auth.token
      logger.info "token = #{token}"
      @campaign = Campaign.find_by_id session[:campaign_id]

      if @campaign
        feed = {
          :message     => params[:message],
          :name        => @campaign.name,
          :link        => BITLY.shorten( current_user.link_for_facebook(@campaign) ).short_url,
          :picture     => "#{APP_CONFIG['domain']}#{@campaign.logo.url(:small)}",
          :description => @campaign.description,
          :caption     => "http://tipdem.com"
        }
        @response_hash = MiniFB.post(token,'me',:type => :feed, :params => feed)
        @message="Succesfully published"
        logger.info "Response to Post: #{@response_hash}"
      else
        @message="You must choose a campaign first"
      end
    else
      logger.info "No se autentico con Facebook"
      @message="An error ocurred. Try later, please."
    end
    logger.info "Message=#{@message}"
    render :inline => @message

  end


  def campaign_info
    campaign_id = params[:campaign_id]
    logger.info "More info about campaign: #{campaign_id}"
    campaign = Campaign.find campaign_id
    render :update do |page|
      page << "$('#more_#{campaign_id}').show();"
      page.replace_html('more_#{campaign_id}', :partial =>'campaign_data', :locals => {:campaign => campaign })
    end
  end

  def my_campaigns
    session[:campaign_id]=nil

  end

  def campaign_details_promotion
    @campaign = Campaign.find_by_id params[:campaign_id] || session[:campaign_id]
    render :update do |page|
      #page.set_msg_promotion("Eligio #{campaign.name}")
      page.replace_html('#campaign_details','')
      page.replace_html('#campaign_details', :partial =>'campaign_details', :object => @campaign )
    end

  end



  def display_promotion
    @post = current_user.posts.last(:conditions => {:campaign_id => params[:campaign_id]})
    @campaign = Campaign.find params[:campaign_id]

    unless @post
      puts "No existe un post con estas condicones, creo "

      #TODO borrar lo posterior al OR. Es un parche para mis datos locales.
      default_message = @campaign.default_message || @campaign.description.slice(0,120)
      @post = current_user.posts.build(:campaign => @campaign,
        :message => default_message )
    end

    render :update do |page|
      #page.set_msg_promotion("Eligio #{campaign.name}")
      page.replace_html('#campaign_details','')

    end

  end

 def chains
    #TODO Pasar al model
    begin
      @channels = Channel.find :all
      @meme_hits_per_channel = Hash.new
      @client_hits_per_channel = Hash.new
      @fished_per_channel = Hash.new

      @channels.each do |channel|
        @meme_hits_per_channel[channel] = LandingPageHit.count :all, :conditions => ["channel = ? and fisher_id = ?", channel,current_user.id ]
        #  logger.info " For #{channel.name} are #{@meme_hits_per_channel[channel]} hits"
        @client_hits_per_channel[channel] = ClientHit.count :all, :conditions => ["channel = ? and fisher_id = ?", channel,current_user.id ]
        @fished_per_channel[channel] = Chain.count :all, :conditions => ["channel = ? and fisher_id = ?", channel,current_user.id ]
        logger.info(" #{current_user.login} have for #{channel.name}: #{@meme_hits_per_channel[channel]} hits or chains")
      end

      chain_page

    rescue => ex
      logger.info "#{ex.class}: #{ex.message}"
    end
  end

  #TODO Documentar - ERROR: avanza igual el NEXT de la tabla aunque no debiera!
  def chain_page
    logger.info "request: #{request}"
    order_by = (params[:order_by] || 'user')
    logger.info "Page: #{@current_page} Order by: #{order_by}"
    limit = 5;

    if (@max_page.nil?)
      results = Chain.count :all, :conditions => ['fisher_id = ?', current_user.id]
      logger.info "results: #{results}"
      @max_page = (results.to_f/limit).ceil
      logger.info "max page: #{@max_page}"
    end

    page = params[:page] || 1
    if page.to_i > @max_page.to_i
      @current_page = @max_page
    elsif page.to_i < 1
      @current_page = 1
    else
      @current_page = page
    end

    @chains = Chain.find :all, :conditions => ['fisher_id = ?', current_user.id], :include => [ :channel, :fish],
      :limit => limit, :offset => ( (@current_page.to_i - 1) * limit)

    @data_of_fishes = Hash.new
    @chains.each do |chain|
      logger.info "* #{chain.fish.id}: #{chain.fish.login}"
      values_of_fisher = Hash.new
      values_of_fisher [:meme] = LandingPageHit.count :all, :conditions => ["fisher_id = ?", chain.fish.id]
      values_of_fisher [:client] = ClientHit.count :all, :conditions => ["fisher_id = ?", chain.fish.id]
      values_of_fisher [:chains] = Chain.count :all, :conditions => ["fisher_id = ?", chain.fish.id ]
      @data_of_fishes[chain.fish.id] = values_of_fisher;
    end

    if request.xhr?
      render :update do |page|
        page.replace_html('chains_table', :partial =>'chains_display', :locals => {:chains => @chains,
            :current_page => @current_page,
            :max_page => @max_page,
            :data_of_fishes => @data_of_fishes} )
      end
    end

  end



  def update_profile
    #Pasar parte al model ?
    @msgs = Array.new
    @user = current_user
    logger.info("Update Profile: #{@user.login}")

    logger.debug "New password: #{params[:new_password]}"
    logger.debug "Password confirmation: #{params[:password_confirmation]}"
    if (params[:new_password].length > 0  )
      @user.password = params[:new_password]
      @user.password_confirmation = params[:password_confirmation]
    end

    logger.debug "New email #{params[:new_email]}"
    logger.debug "Email confirmation: #{params[:email_confirmation]}"
    if (params[:new_email].length > 0)
      @user.email = params[:new_email]
      @user.email_confirmation = params[:email_confirmation]
    end

    valid = @user.valid?
    #check if the modified user is valid
    if (valid)
      logger.debug"user is valid #{valid}"
      #then check if email or password really changed
      if ( @user.email_changed? || @user.password_changed? )
        begin
          #save the modified user
          saved = @user.save!
          logger.debug "User saved? #{saved}"
        rescue Exception => ex
          #oops! something go very bad
          logger.info "#{ex.class}: #{ex.message}"

          render :update do |page|
            page.display_messages @msgs
          end
        else
          #no problems so updated.
          @msgs << "Successfully updated."
          logger.info "#{@msgs}"

          render :update do |page|
            #page.form.reset
            page << "$('#update_form').find('input[type=text]').not('input[readonly]').val('')"
            page.display_messages @msgs
            page << "$('user_email').val('#{@user.email}')"
          end
        end
      else #email or password changed? returned false
        #volunter wasn't changed so nothing to display
        logger.info "No changes."
        @msgs << "No changes"
        render :update do |page|
          page.display_messages @msgs
        end
      end
    else #save! returned false
      #Validations errors display
      logger.info "RecordInvalid:"
      @user.errors.each_full do |error|
        @msgs << error
      end
      logger.info "#{@msgs.last}"

      render :update do |page|
        page.display_messages @msgs
      end
    end

  end

=end

