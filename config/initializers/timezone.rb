# -*- encoding : utf-8 -*-
module ActiveRecord
  module ConnectionAdapters # :nodoc:
    module Quoting
      # Convert dates and times to UTC so that the following two will be equivalent:
      # Event.all(:conditions => ["start_time > ?", Time.zone.now])
      # Event.all(:conditions => ["start_time > ?", Time.now])
      def quoted_date(value)
        value.respond_to?(:utc) ? value.utc.to_s(:db) : value.to_s(:db)
      end
    end
  end
end
