ActiveAdmin.register Campaign::Base, :as => "Campaigns" do
  filter :status, :as => :select,
  :collection => ["incomplete","waiting_pay","waiting_approval","unstarted",
    "expired","out_of_money","active","inactive","error"]

  index do
    column :id do |campaign|
      link_to campaign.id, admin_campaign_path(campaign.id)
    end
    column :owner do |campaign|
      link_to campaign.owner.try(:username), admin_user_path(campaign.owner)
    end
    column :name
    column :description
    column :status
    column :default_message
    column :begin_date
    column :have_end_date
    column :end_date
    column :created_at
    column :landing_page do |campaign|
      link_to campaign.landing_page.try(:id), admin_landing_page_path(campaign.landing_page)
    end
    column do |campaign|
      link_to "Approve", approve_admin_campaign_path(campaign), :method => :put
    end
    column do |campaign|
      link_to "Disapprove", disapprove_admin_campaign_path(campaign), :method => :put
    end
    default_actions
  end

  member_action :approve, :method => :put do
    campaign = Campaign::Base.find(params[:id])
    campaign.approve!
    redirect_to :action => :show, :notice => "Approved!"
  end

  member_action :disapprove, :method => :put do
    campaign = Campaign::Base.find(params[:id])
    campaign.disapprove!
    redirect_to :action => :show, :notice => "Disapproved!"
  end

end
