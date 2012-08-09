FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@factory.com" }
    sequence(:username) { |n| "user#{n}"}
    password "lapassword"
    password_confirmation { |u| u.password }
    confirmed_at Time.now
    approved true
  end
end