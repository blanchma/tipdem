# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Campaign" do

  describe "in first step" do
    before(:each) do
      @user = Factory(:user)      
      @campaign = Factory(:campaign, :owner => @user)
    end

    it "should have an owner" do      
      @campaign.owner.should == @user
    end

  end
end
