# -*- encoding : utf-8 -*-
=begin

#TODO Documentar que gemas y en que versiones estamos usandolas
require 'oauth'
require 'json'
require 'twitter_user'
require 'twitter_oauth'

class UserPanelController < ApplicationController

  before_filter :login_required
  before_filter :set_facebook_session
  helper_method :facebook_session
  


  def home
    #TODO Falta lógica de Default. Quizas Profile o el modo más activo de promoción.
    #redirect_to :action => 'email_choose_sign'
  end

  def profile
    @volunteer = current_volunteer
  end

  #Ajax function-target. Update email or password of the user in the Update Profile section
  def update_profile
    #Pasar parte al model ?
    @msgs = Array.new
    @volunteer = current_volunteer
    logger.info("Update Profile: #{@volunteer.login}")

    logger.debug "New password: #{params[:new_password]}"
    logger.debug "Password confirmation: #{params[:password_confirmation]}"
    if (params[:new_password].length > 0  )
      @volunteer.password = params[:new_password]
      @volunteer.password_confirmation = params[:password_confirmation]
    end

    logger.debug "New email #{params[:new_email]}"
    logger.debug "Email confirmation: #{params[:email_confirmation]}"
    if (params[:new_email].length > 0)
      @volunteer.email = params[:new_email]
      @volunteer.email_confirmation = params[:email_confirmation]
    end

    valid = @volunteer.valid?
    #check if the modified volunteer is valid
    if (valid)
      logger.debug"Volunteer is valid #{valid}"
      logger.debug"Email changed? #{@volunteer.email_changed?}"
      logger.debug"Password changed? #{@volunteer.password_changed?}"
      #then check if email or password really changed
      if ( @volunteer.email_changed? || @volunteer.password_changed? )
        begin
          #save the modified volunteer
          saved = @volunteer.save!
          logger.debug "Volunter saved? #{saved}"
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
            page << "$('volunteer_email').val('#{@volunteer.email}')"            
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
      @volunteer.errors.each_full do |error|
        @msgs << error
      end
      logger.info "#{@msgs.last}"

      render :update do |page|
        page.display_messages @msgs
      end
    end

  end

  def email_choose_sign
    @email_signs = EmailSign.all
    @email_signs.each do |sign|
      logger.info "Email sign: #{sign.image_path}"
    end

  
  end

  def show_as_code
    begin
      @img = EmailSign.find(params[:sign_id])
      @channel = Channel.find_by_name 'email'
      @sign = "<table align='center' width='98' cellpadding='0' cellspacing='0' border='0'>
  <tr><td><a href='#{APP_CONFIG['domain']}/see/qless/#{current_volunteer.essence}/#{@channel.crypt}'><img src='#{APP_CONFIG['domain']}#{@img.image_path}' style='border: none' /></a></td></tr>
  </table>"
      @sign.gsub("/\n/", "")
      logger.debug "HTML Sign: #{@sign}"
      render :inline => @sign
    rescue => ex
      logger.info "Exception: #{ex.class}: #{ex.message}"
    else

    end

  end


  def promotion
    #Si pongo esto antes, no me renderiza las firmas

    @campaigns = Volunteer.find_by_id(current_volunteer.id).campaigns
    session[:campaign_id] = @campaigns.first.id
    messages = TwitterAdvert.find_by_campaign_id(session[:campaign_id]).messages
    @twitter_message = messages.find_by_locale session[:locale]
    messages = FacebookAdvert.find_by_campaign_id(session[:campaign_id]).messages
    @facebook_message = messages.find_by_locale session[:locale]
    @client = session[:client]
    
    logger.debug "Twitter Message contains: #{@twitter_message.message}"
    facebook
    twitter
  end

  def campaigns
        #@campaign = Campaign.new
        #@point_campaign = PointCampaign.new
        #@money_campaign =MoneyCampaign.new

	render "campaings"
  end

  def create_campaing
     puts "Campaign " , params[:campaign]
     puts "Point " , params[:point_campaign]
     puts "Money " , params[:money_campaign]

     @campaign = Campaign.new(params[:campaign])


     unless @campaign.valid?
      puts "ERROR"
      @campaign.errors.each_full { |msg| logger.info "#{msg}"}
      render :template => 'user_panel/show_errors.rjs'
      return
     end




     if params[:point_campaign] == nil and params[:money_campaign] == nil
	puts("debo mandar un mensaje diciendo q elija algun metodo")
     elsif params[:point_campaign] == nil and params[:money_campaign] != nil
	puts("campaña por monedas")
     elsif params[:point_campaign] != nil and params[:money_campaign] == nil
	puts("campaña por puntos")
        @point_campaign = PointCampaign.new(params[:point_campaign])
        @campaign.reference = @point_campaign
	@campaign.client_id = Client.find(1).id
        @campaign.volunteer_id = current_volunteer.id
        puts("acabo de asociar la campaña creada con el voluntario; " , current_volunteer.login)
        @campaign.save
        @point_campaign.save
	#pepe = ProductAward.new({"name"=>"I-Pod", "description"=>"viene de China"})
        #pepe.save
        @reward = Reward.new
	puts("id de la campaña recien creado " ,@point_campaign.id )
        @reward.point_campaign_id = @point_campaign.id
	@reward.product_award_id = ProductAward.find(1).id
	@reward.save
        
        current_volunteer.campaigns << @campaign
	print "agregando la campaña" 
	current_volunteer.campaigns.each do  |camp|
		puts "campaña asociada al vloluntario created " , camp
	end
        #puts("busqueda inversa " , PointCampaign.find(@point_campaign.id).campaign.name.to_s)
	#prueba de borrar la campaña junto con su subclase por polimorfismo	
	#@campaign.remove_campaign()
     end
     
     render :update do |page|
              page <<  "window.parent.location = '#{url_for(:controller => 'user_panel', :action => 'home' )}' "
      end
     #redirect_to :action => :home
  end



  def my_campaigns
	
      @channels = Channel.find :all
      @fished_per_channel = Hash.new
      @campaigns_per_volunteer = Array.new
      puts "comenzar a iterar por las campañas del usuario logeado " , current_volunteer.login
      current_volunteer.campaigns.each do  |camp|
		puts "agregadno campaña: " , camp.name
		@campaigns_per_volunteer << camp
      end
      
      #@products_per_campaign  = Hash.new{|hash, key| hash[key] = Array.new;}
      @products_per_campaign  = Hash.new

      @campaigns_per_volunteer.each do |camp|
        #aca voy a tomar los premios asociados a las campañas, si la campaña es por puntos
        if camp.reference_type = 'PointCampaign'
		puts ("reference id " , camp.reference_id)
		rewards = Reward.find :all, :conditions => ["point_campaign_id = ?", camp.reference_id]
                rewards.each do |reward|
                        if @products_per_campaign.has_key? camp.name
                		@products_per_campaign[camp.name] << ProductAward.find(reward.product_award_id)
			else
				l = Array.new
                                l << ProductAward.find(reward.product_award_id)
			        @products_per_campaign[camp.name] = l
			end
			puts("agregando el priducto " , ProductAward.find(reward.product_award_id).name , camp.name   )
		end         
	end

        @channels.each do |channel|
           #@fished_per_channel[camp.name+channel.name] = Chain.count :all, :conditions => ["channel_id = ? and fisher_id = ? and campaign_id = ?", channel.id,current_volunteer.id, camp.id]
           @fished_per_channel[camp.name+channel.name] = Chain.count :all, :conditions => ["channel_id = ? and campaign_id = ?", channel.id, camp.id]
           logger.info(" #{current_volunteer.login} have for #{camp.name} and #{channel.name}: #{@fished_per_channel[camp.name+channel.name]} hits or chains")
        end
     end
     @products_per_campaign.each_key do |key|
  	puts("campaña " , key , " producto " , @products_per_campaign[key])
     end


     #products_per_campaign.each do |p|
	#puts("producto asociado a la campaña " , camp.name , camp.reference_id , p.name , p.description)
     #end
  end

 
  #TODO Documentar
  def chains
    #TODO Pasar al model
    begin
      @channels = Channel.find :all
      @meme_hits_per_channel = Hash.new
      @client_hits_per_channel = Hash.new
      @fished_per_channel = Hash.new

      @channels.each do |channel|
        @meme_hits_per_channel[channel] = LandingPageHit.count :all, :conditions => ["channel_id = ? and fisher_id = ?", channel.id,current_volunteer.id ]
        #  logger.info " For #{channel.name} are #{@meme_hits_per_channel[channel]} hits"
        @client_hits_per_channel[channel] = ClientHit.count :all, :conditions => ["channel_id = ? and fisher_id = ?", channel.id,current_volunteer.id ]
        @fished_per_channel[channel] = Chain.count :all, :conditions => ["channel_id = ? and fisher_id = ?", channel.id,current_volunteer.id ]
        logger.info(" #{current_volunteer.login} have for #{channel.name}: #{@meme_hits_per_channel[channel]} hits or chains")
      end

      chain_page

    rescue => ex
      logger.info "#{ex.class}: #{ex.message}"
    end
  end

  #TODO Documentar - ERROR: avanza igual el NEXT de la tabla aunque no debiera!
  def chain_page
    logger.info "request: #{request}"   
    order_by = (params[:order_by] || 'volunteer')
    logger.info "Page: #{@current_page} Order by: #{order_by}"
    limit = 5;

    if (@max_page.nil?)
      results = Chain.count :all, :conditions => ['fisher_id = ?', current_volunteer.id]
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
    
    @chains = Chain.find :all, :conditions => ['fisher_id = ?', current_volunteer.id], :include => [ :channel, :fish], 

      :limit => limit, :offset => ( (@current_page.to_i - 1) * limit) 
    print "CHAINS........................" , @chains
  
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


  def facebook
    #logger.info"Current volunteer: #{current_volunteer.login}"
    session[:id_for_facebook]= current_volunteer.id
  end


  #TODO Documentar
  def connect_facebook
    #register with fb
    facebook_user = FacebookUser.find_or_create_facebook_uid(facebook_session.user,current_volunteer.id)
    logger.debug "Campaign id: #{session[:campaign_id]}"
    facebook_advert = FacebookAdvert.find_by_campaign_id(session[:campaign_id])
    
    logger.debug "FacebookSession: #{facebook_session.user}"
    facebook_advert.publish(facebook_session.user, current_volunteer, session[:locale])

    #logger.debug "Friends count: #{user.friends.size}"

    @count = 0
    facebook_session.user.friends.each do |user|
      @count+= 1
    end

    logger.debug "Size of collection: #{facebook_session.user.friends.size}"
    logger.debug "Friends count: #{@count}"
    facebook_user.friends = @count
    facebook_user.save(false)
    #redirect_to edit_user_path(user)
    #@current_fb_user.link_fb_connect(facebook_session.user.id) unless @current_user.fb_id == facebook_session.user.id

    facebook_session
    flash[:facebook]="Succesfully published"
    redirect_to :action => :promotion
    #logger.info("Connecting to Facebook account because user wired")
    #@current_fb_user.link_fb_connect(facebook_session.user.id) unless @current_user.fb_id == facebook_session.user.id
  end


  #TODO Documentar
  def twitter
    @twitter_user = TwitterUser.new
    session[:id_for_twitter] = current_volunteer.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @twitter_user }
    end
  end

  #TODO Documentar
  def connect_twitter
    callback = "#{APP_CONFIG['domain']}/account/callback_twitter";
    @twitter_user = TwitterUser.new
    @twitter_client = @twitter_user.client
    @request_token = @twitter_user.get_request_token(callback)

    #@request_token = @twitter_user.get_request_token callback
    session[:request_token] = @request_token.token
    session[:request_token_secret] = @request_token.secret
    redirect_to @request_token.authorize_url
    
    #TODO Abrir la ventana de twitter en un popup modal en jquery (fancybox quizas)
    # render :update do |page|
    #    page <<  "javascript: window.open('#{@request_token.authorize_url}','Connect to Twitter','status=false,menubar=false,scrollbars=false,location=yes') "
    # end

  end

  def select_campaign
    session[:campaign_id] = params[:campaign_id]
  end

  #TODO Documentar
  def callback_twitter
    logger.debug "Callback twitter"
    @twitter_user = TwitterUser.new
    @twitter_client = @twitter_user.client
    #logger.debug "RequestToken in callback is #{@twitter_client}"

    @access_token = @twitter_client.authorize(session[:request_token],session[:request_token_secret],
      :oauth_verifier => params[:oauth_verifier])

    logger.debug "Twitter Client is authorized #{@twitter_client.authorized?}"

    if  @twitter_client.authorized?
      link = current_volunteer.link_for_twitter session[:client]
      #TODO No es dinámico todavia
      session[:campaign_id] = (Campaign.find_by_name 'QLess-Test').id if session[:campaign_id].nil?
      
      logger.debug "Campaign id: #{session[:campaign_id]}"
      
      message = TwitterAdvert.find_by_campaign_id(session[:campaign_id]).messages.find_by_locale(session[:locale]).message
      logger.debug "message = #{message} and link = #{link}"
      @twitter_client.update("#{message} #{link}")
      
      @count_friends = @twitter_client.info['friends_count']
      @twitter_client.friends.each do |friend|
        #logger.debug "Friend #{@count_friends} = #{friend}"
        @twitter_client.message(friend['name'],message) 
      end

      logger.debug "Tiene #{@count_friends} amigos."
      logger.info "@TwitterUser name is #{@twitter_client.info['name']}"

      tw_user = TwitterUser.find_or_create_by_name(@twitter_client.info['name'])
      if (tw_user.nil?)
        logger.debug "New Twitter User created"
        #We need to save without validations
        tw_user.token= @access_token.token
        tw_user.secret= @access_token.secret
        tw_user.name=@twitter_client.info['name']
        tw_user.volunteer_id= current_volunteer.id
      else
        logger.debug "Twitter User finded"
        tw_user.friends = @count_friends
      end

      logger.debug "Twitter User saved? #{tw_user.save(false)}"

      session[:id_for_twitter]
      flash[:twitter]="Sucessfully posted."
      redirect_to :action => :promotion
    else      
      logger.info "Failed to get user info via OAuth"
      # The user might have rejected this application. Or there was some other error during the request.
      flash[:twitter] = "Authentication failed"
      return
    end
  end


  rescue_from Facebooker::Session::SessionExpired do |exception|
    logger.info "Facebook exception: #{exception.message}"
    @current_volunteer = current_volunteer.id
    clear_facebook_session_information
    clear_fb_cookies!
    reset_session # i.e. logout the user
    set_auth_cookie @current_volunteer
    flash[:facebook]="You have been disconnected from Facebook because #{exception.message}."
    redirect_back_or_default(promotion_path)
  end

end

=end
