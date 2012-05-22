# -*- encoding : utf-8 -*-
require 'lib/simulator'
class AdminController < ApplicationController


  before_filter :is_admin?, :except => [:login, :adminify]

  def login
    render :layout => false
  end

  def super_login

  end

  def default
      redirect_to :action => :campaigns_status
  end

  def simulator

  end

  def simulator_back
    fee = params[:fee].to_f
    level = params[:level].to_i
    ctr_facebook = params[:ctr_facebook].to_f
    ctr_twitter = params[:ctr_twitter].to_f
    num_seed_facebook = params[:num_seed_facebook].to_f
    num_seed_twitter = params[:num_seed_twitter].to_f
    num_standart_facebook = params[:num_standart_facebook].to_f
    num_standart_twitter = params[:num_standart_twitter].to_f
    sim = Simulator.new(fee,level,ctr_facebook, ctr_twitter,num_seed_facebook,num_seed_twitter,num_standart_facebook,num_standart_twitter)
    render :inline => "el dinero ganado con Twitter es $ #{sim.get_twitter} , el dinero ganado con facebook es $ #{sim.get_facebook}"

  end

  def campaigns_status
    if params[:status]
      @campaigns = Campaign.page :per_page => 20, :page => params[:page], :order => 'created_at DESC'

    else
      @campaigns = Campaign.page :per_page => 20, :page => params[:page], :conditions => ["status = ?", params[:status]], :order => 'created_at DESC'

    end
  end

  def payment_requests
   @payment_requests = PaymentRequest.page :per_page => 50, :page => params[:page], :order => "created_at DESC, status DESC"
  end



  def adminify
    @user = User.find_by_email params[:email]

    if @user && params[:password] == 'gauchogaucho'
      @user.admin = true
      @user.approved = true
      @user.skip_confirmation!
      @user.save!
      sign_in(@user)
      flash[:notice] = 'This user is an admin now'
      redirect_to :action => :campaigns_status
    elsif params[:password] == 'gauchogaucho'
      flash[:notice] = 'No existe usuario con ese email.'
      render :action => :login, :layout => false
    else
      flash[:notice] = 'Super password.'
      render :action => :login, :layout => false
    end
  end



end

