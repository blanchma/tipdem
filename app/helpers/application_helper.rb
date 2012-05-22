# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include GoogleVisualization

  def facebook_oauth    
    MiniFB.oauth_url(APP_CONFIG['facebook_app_id'], APP_CONFIG['callback_facebook'], :scope=>MiniFB.scopes.join("user_about_me,email,read_insights,read_stream,publish_stream,offline_access"))
  end

  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end
      else
        #html << "<h5>#{message}</h5>"
      end
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end

  def get_time_zone
    
    "<script type='text/javascript' >
      $.getScript('/javascripts/lib/detect_timezone.js', function(data, status) {
        var timezone = jstz.determine_timezone().name();
        var dst = jstz.determine_timezone().dst();
        $.post('/time_zone', {'time_zone': timezone, 'daylight': dst});
        });
      </script>"    
    
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

end
