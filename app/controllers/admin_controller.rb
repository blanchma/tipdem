# -*- encoding : utf-8 -*-
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

  def campaigns_status
    @campaigns = Campaign::Base.page(params[:page]).per(20).order('created_at DESC')
    @campaigns.where(:status => params[:status]) if params[:status]
  end

  def payment_requests
    @payment_requests = PaymentRequest.page(params[:page]).per(50).order("created_at DESC, status DESC")
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

