# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Payment Request", %q{
  In order to transfer money to my account
  As a promotor
  I want to ask a payment
} do

  let :user do
   Factory.create :user
  end

  background do    
    login_with user  
  end 
 
  scenario "have enough money and dinero mail account" do
     user.current_money = 100
     user.dinero_mail_account = DineroMailAccount.new(:email => user.email)
     user.save
     visit user_panel
     click_on "Solicitar cobro"
     page.should have_content("la suma de #{number_to_currency(user.current_money, :unit => "$", :format => "%u%n")} ")
     find("#payment_request_submit").click
     page.should have_content("Mis solicitudes de cobro")
     within_table("my_payment_requests") do |row|
       
     end

     
  end

end
