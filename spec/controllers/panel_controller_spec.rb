# -*- encoding : utf-8 -*-
require 'spec_helper'


describe PanelController do
  integrate_views

  before(:each) do
     #@request.env["devise.mapping"] = Devise.mappings[:user]
    @user = Factory.create :user    
    login_with @user
  end

  it "should show user's current money" do
    @user.current_money = RevenueParams::Min_Payment + 1
    visit user_root_path
    page.within("#amount") do      
      page.should have_content(number_to_currency(@user.current_money, :unit => "$", :format => "%u%n"))
    end
  end

  it "shouldn't allow request money" do
    @user.current_money = RevenueParams::Min_Payment - 5
    @user.save
    visit user_root_path
    page.within("#amount") do
      page.should have_content "Fondos insuficientes"
    end

  end



end
