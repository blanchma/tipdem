# -*- encoding : utf-8 -*-
module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    "/"
  end

   def user_panel
    "/my/panel"
  end

   def login
     "/users/sign_in"
   end

end

Spec::Runner.configuration.include(NavigationHelpers)
