# -*- encoding : utf-8 -*-
class WelcomeController < ApplicationController

before_filter :last_campaigns

  def last_campaigns
    @last_campaigns = Campaign.active.all(:limit => 5, :order => "created_at DESC")
  end

  def p_funcionamiento
  end

  def c_funcionamiento
  end

  def servicios
  end

  def contacto
  end

  def equipo
  end

  def home
  end

  def send_contact
    puts "procesando mensaje"
    puts params[:contact]['name']
    ContactMailer.delay.deliver_contact_email(params[:contact][:email] , params[:contact][:message])
    redirect_to root_path
  end

end

