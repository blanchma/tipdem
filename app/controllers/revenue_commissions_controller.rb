# -*- encoding : utf-8 -*-
class RevenueCommissionsController < ApplicationController

  def index
    @bank_account = BankGlobalAccount.instance
    @commissions = RevenueCommission.page :per_page => 50, :page => params[:page], :order => sort_column + " " + sort_direction
    render :layout => "admin"
  end


  private

  def sort_column
    RevenueCommission.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end

