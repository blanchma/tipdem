# -*- encoding : utf-8 -*-
require 'spec_helper'


describe WelcomeController do
  integrate_views
  
  controller_name :welcome

  it "home" do
    visit "/"
    page.should have_content("La mejor herramienta")
  end
  

end
