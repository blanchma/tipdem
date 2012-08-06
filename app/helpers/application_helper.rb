# -*- encoding : utf-8 -*-
module ApplicationHelper
  include GoogleVisualization


  def errors_for(object, header=nil,message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank? && header
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
      $(document).ready(function() {
        var timezone = jstz.determine().name();
        console.log('time_zone: ' + timezone );
        $.cookie('time_zone', timezone );
      });
    </script>".html_safe
  end


  def google_analytics
    "var _gaq=_gaq||[];_gaq.push(['_setAccount','UA-23135253-2']);_gaq.push(['_trackPageview']);(function(){var b=document.createElement('script');b.type='text/javascript';b.async=true;b.src=('https:'==document.location.protocol?'https://ssl':'http://www')+'.google-analytics.com/ga.js';var a=document.getElementsByTagName('script')[0];a.parentNode.insertBefore(b,a)})();".html_safe
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

end
