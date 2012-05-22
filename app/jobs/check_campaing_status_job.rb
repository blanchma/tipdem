# -*- encoding : utf-8 -*-
class CheckCampaingStatusJob
  def self.perform
    Campaign.active.each do |camp|
      old_status = camp.status
      new_status = camp.check_status
      if old_status != new_status
        cron_log "#{camp.id} changed from #{old_status} to #{new_status}"
      end
    end
  end
end
