# -*- encoding : utf-8 -*-
class DineroMailAccountsController < ApplicationController
  layout :set_layout

  before_filter :authenticate_user!,:find_user

  
  def new
    @dinero_mail_account = @user.build_dinero_mail_account
  end

  def create
    @dinero_mail_account = @user.build_dinero_mail_account(params[:dinero_mail_account])
    
    respond_to do |format|
      if @dinero_mail_account.save
        format.html { redirect_to(my_accounts_path, :notice => 'DineroMailAccount was successfully created.') }
        format.js { head :ok}
      else
        format.html { render :action => :new    }
        format.js { render :json => @dinero_mail_account.errors.full_messages,  :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @dinero_mail_account = @user.dinero_mail_account
    @dinero_mail_account.destroy if @dinero_mail_account 

    respond_to do |format|
      format.html { redirect_to :back }
      format.js  { head :ok }
    end
  end
  
  def edit
    @dinero_mail_account = @user.dinero_mail_account
  end
  

  def update
    @dinero_mail_account = @user.dinero_mail_account

    respond_to do |format|
      if @dinero_mail_account.update_attributes(params[:dinero_mail_account])
        format.html { redirect_to(my_accounts_path, :notice => 'DineroMailAccount was successfully updated.') }
        format.js  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js  { render :json => @dinero_mail_account.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  private

  def find_user
    @user = User.find params[:user_id]
  end

  def set_layout
    params[:layout] || 'panel'
  end
  

end
