# -*- encoding : utf-8 -*-
class PanelController < ApplicationController
  before_filter :authenticate_user!, :get_timezone

  def home
    @campaigns = Campaign::Base.active.page(params[:page]).per(10).order(:created_at)
  end

  def get_timezone
    time_zone = cookies["time_zone"]
    logger.info "TimeZone: #{time_zone}"
    Time.zone = ActiveSupport::TimeZone[time_zone]
    current_user.time_zone = time_zone
    current_user.save if current_user.time_zone_changed?
  end

end
