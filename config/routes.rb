# -*- encoding : utf-8 -*-
Tipdem::Application.routes.draw do

  root :to => "welcome#home"

  resources :promotions, :categories
  resource :captcha, :only => [:new]

  resources :chains
  resources :landing_pages do
    get :inactive, :on => :member
  end

  resources :payment_requests do
    member do
      get :admin_edit
      put :admin_update
    end
  end

  resources :campaigns do
    member do
      get :success
      post :activate
      post :disapprove
      get :fail
      get :detailed
    end
    resource :landing_page
    resource :budget do
      get :pay, :on => :member
    end
    resources :posts, :as => :tips do
      get :go, :on => :collection
      post :stop, :on => :member
    end
    resource :categories, :path => :classification, :path_names => { :edit => :choose }
  end



  match "/step/setup/:campaign_id" => "campaigns#new", :as => :step_setup
  match "/step/budget/:campaign_id" => "budgets#new", :as => :step_budget
  match "/step/categories/:campaign_id" => "categories#edit", :as => :step_categories
  match "/step/landing/:campaign_id" => "landing_pages#new", :as => :step_landing
  match "/step/pay/:campaign_id" => "campaigns#pay", :as => :step_pay
  match "my/campaigns/actives/" => "campaigns#index_actives", :as => :my_campaigns
  match "my/campaigns/inactives" => "campaigns#index_inactives", :as => :inactive_campaigns
  match "my/links" => "chains#create", :as => :chain_user
  match "/my/panel" => "panel#home", :as => :user_root
  match "/my/profile" => "users#edit", :as => :edit_registration, :via => :get
  match "/my/profile" => "users#update", :as => :registration, :via => :put
  match "/unregister/:id" => "users#destroy", :as => :unregister, :via => :delete
  match "register" => "users#create", :as => :user_registration, :via => :post

  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "sessions",
    :registrations => "registrations" }

#  match "users" => "#index", :as => :devise_for
#  match "user/:id/approve" => "users#approve", :as => :approve
#  match "user/:id/confirm" => "users#confirm", :as => :confirm
#  match "users/captcha" => "users#captcha", :as => :captcha
#  match "/user/confirmation" => "confirmations#update", :as => :update_user_confirmation, :via => :put
#  match "user/:id/send_confirmation" => "users#send_confirmation", :as => :my_confirmation

  resources :users do
    member do
      post :update_signup
      post :toggle_recommendations
      post :email_confirmation, :to => "users#send_confirmation"
    end

    resource :categories
    resource :dinero_mail_accounts
  end

  match "my/accounts" => "panel#accounts", :as => :my_accounts
  match "/promote/:id" => "panel#promote_campaign", :as => :promote_campaign
  match "see/:campaign/*link" => "landing_pages#show"
  match "my/:action" => "panel#index"
  match "user/complete_signup" => "users#complete_signup", :as => :complete_signup
  match "/auth/:provider/callback" => "authentications#create"
  match "/time_zone" => "application#set_timezone"
  match "/visit/:id" => "landing_pages#client_page", :as => :visit
  match "/admin" => "admin#default", :as => :admin
  match "/adminify" => "admin#adminify", :as => :adminify

#  mount Resque::Server.new, :at => "/resque"

  match "/:controller(/:action(/:id))"
end

