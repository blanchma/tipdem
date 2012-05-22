# -*- encoding : utf-8 -*-
# To change this template, choose Tools | Templates
# and open the template in the editor.

class PaymentRequestsController < ApplicationController

  layout 'panel'

  before_filter :authenticate_user!, :confirm_user!
  before_filter :is_admin?, :only => [:admin_edit]

  def new
    @payment_request = current_user.payment_requests.last
    if @payment_request && (@payment_request.in_progress? || @payment_request.created?)
      render :in_progress
    else
      @payment_request= PaymentRequest.new
      @dinero_mail_account= DineroMailAccount.new
      render :new
    end
  end

  def create
    @payment_request = PaymentRequest.new(:user_id => current_user.id , :requested_money => current_user.current_money ,:dinero_mail_email => current_user.dinero_mail_account.email )

    #no hace falta se agrego antes la relacion con la cuenta de DineroMail
=begin
    @dinero_mail =  DineroMailAccount.new( :email => params[:dinero_mail_email], :user_id => current_user.id)

    if params[:dinero_mail_email] && @dinero_mail.valid?
      current_user.dinero_mail_account = @dinero_mail
      current_user.save
    end
=end
    respond_to do |format|
      if  @payment_request.save
        flash[:notice]="Solicitud creada con éxito."
        format.html { redirect_to payment_requests_path }
      else
        format.html { render :action => "new" }

      end
    end
  end

  def show
    @payment_request = PaymentRequest.find(params[:id])
  end

  def destroy
    @payment_request = PaymentRequest.find(params[:id])
    if @payment_request.created_at
      @payment_request.destroy
      flash[:notice]="La solicitud de cobro fue cancelada."
    else
      flash[:notice]="La solicitud de cobro no pudo ser cancelada."
    end
    render :action => :index
  end

  def index
    @payment_requests = current_user.payment_requests.all(:order => "created_at DESC")
  end

  def edit
    @payment_request = PaymentRequest.find(params[:id])
  end

  def admin_edit
    @payment_request = PaymentRequest.find(params[:id])
    @revenues = @payment_request.user.revenues.page :per_page => 20, :page => params[:page]
    render :layout => "admin"
  end

  def admin_update
     @payment_request = PaymentRequest.find(params[:id])
    respond_to do |format|
      if @payment_request.update_attributes(params[:payment_request])
        flash[:notice]='La solicitud de pago fue actualizada.'
        format.html { redirect_to :action => :admin_edit }
        #format.xml  { head :ok }
      else
        format.html { render :action => :admin_edit }
        #format.xml  { render :xml => @rest_example.errors, :status => :unprocessable_entity }
      end
    end
  end


end

