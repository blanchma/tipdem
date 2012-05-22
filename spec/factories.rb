# -*- encoding : utf-8 -*-
Factory.define :campaign do |f|
    f.sequence(:name) { |n| "Campañola#{n}" }
    f.description "Factory description"
    f.default_message "Suggested message"
end

Factory.define :user do |f|
  f.sequence(:email) { |n| "email#{n}@dot.com" }
  f.sequence(:username) { |n| "user_test#{n}"}
  f.password "lapassword"  
  f.password_confirmation { |u| u.password }
  f.confirmed_at Time.now
  f.approved true
end
