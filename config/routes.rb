# -*- encoding : utf-8 -*-
Tipdem::Application.routes.draw do

  ActiveAdmin.routes(self)

  root :to => "welcome#home"

  resources :promotions, :categories
  resource :captcha, :only => [:new]

  resources :chains
  resources :landing_pages do
    get :inactive, :on => :member
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
    resource :rewards do
      get :pay, :on => :member
    end
    resources :posts, :path => :tips do
      get :go, :on => :collection
      post :stop, :on => :member
    end
    resource :categories, :path => :classification, :path_names => { :edit => :choose }
  end

  match "/step/setup/:campaign_id" => "campaigns#new", :as => :step_setup
  match "/step/rewards/:campaign_id" => "rewards#new", :as => :step_rewards
  match "/step/categories/:campaign_id" => "categories#edit", :as => :step_categories
  match "/step/landing/:campaign_id" => "landing_pages#new", :as => :step_landing
  match "/step/pay/:campaign_id" => "campaigns#pay", :as => :step_pay
  match "my/campaigns/actives/" => "campaigns#actives", :as => :my_campaigns
  match "my/campaigns/inactives" => "campaigns#inactives", :as => :inactive_campaigns
  match "my/links" => "chains#create", :as => :chain_user
  match "/my/panel" => "panel#home", :as => :user_root
  match "/my/profile" => "users#edit", :as => :edit_registration, :via => :get
  match "/my/profile" => "users#update", :as => :registration, :via => :put

  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"}

  resources :users do
    member do
      post :update_signup
      post :toggle_recommendations
      post :email_confirmation, :to => "users#send_confirmation"
    end

    resource :categories
    resources :accounts
  end

  match "/promote/:id" => "panel#promote_campaign", :as => :promote_campaign
  match "my/:action" => "panel#index"
  match "user/complete_signup" => "users#complete_signup", :as => :complete_signup
  match "/auth/:provider/callback" => "authentications#create"
  match "/time_zone" => "application#set_timezone"

  match "see/:id", :to => "landing_pages#show"
  match "see/:id/:user_id", :to => "landing_pages#show"
  match "see/:id/:user_id/:channel", :to => "landing_pages#show"


#  mount Resque::Server.new, :at => "/resque"

  match "/:controller(/:action(/:id))"
end

