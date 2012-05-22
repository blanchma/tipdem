# -*- encoding : utf-8 -*-
# To change this template, choose Tools | Templates
# and open the template in the editor.

module PanelHelper
  
  def fb_login_button_with_permissions(options={})
    options = {:result_url => "/facebook_connect", :permissions => 'publish_stream'}.update(options)
    fb_login_button("javascript:FB.Connect.showPermissionDialog('#{options[:permissions]}', function(perms){window.location='#{options[:result_url]}';})")
  end

  def set_msg_first_step(message)
    page << "$('#first_step_error').html('');$('#first_step_error').html('<span>#{message}</span').effect('highlight', {}, 3000); "
  end

  def set_msg_point_campaign_form(message)
    page.remove("#new_point_campaign .valid_msg")
    page << "$('#point_campaign_form_message').html('');$('#point_campaign_form_message').html('<span>#{message}</span>').effect('highlight', {}, 3000); "
  end

  def set_msg_facebook_adv_form(message)
    page.remove("#new_facebook_advert .valid_msg")
    page << "$('#facebook_form_message').html('');$('#facebook_form_message').html('<span>#{message}</span>').effect('highlight', {}, 3000); "
  end

  def set_msg_twitter_adv_form(message)
    page.remove("#new_twitter_advert .valid_msg")
    page << "$('#twitter_form_message').html('');$('#twitter_form_message').html('<span>#{message}</span>').effect('highlight', {}, 3000);"
  end

  def set_msg_landing_page_form(message)
    page.remove("#landing_page_form .valid_msg")
    page << "$('#landing_form_message').html('');$('#landing_form_message').html('<span>#{message}</span>').effect('highlight', {}, 3000);"
  end

  def set_product_message(product_id, message)
    page << "$('.form_message').html('')"
    #page << "console.log('id is #{product_id}')";
    page << "$('#form_product_#{product_id}').html('');$('#form_product_#{product_id}').html('<span>#{message}</span>').effect('highlight', {}, 3000);"
  end

  def set_msg_promotion(message)
    page << "$('#promotion_msg').html('');$('#promotion_msg').html('<span>#{message}</span>').effect('highlight', {}, 3000);"
  end

 
  
end
