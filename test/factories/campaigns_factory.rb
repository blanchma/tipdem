FactoryGirl.define do

  factory :campaign, class: Campaign::Base do
    name              { Random.country }
    description       { Random.paragraphs[0...300]}
    default_message   { Random.paragraphs[0...100]}
    have_end_date     false
    association(:landing_page, factory: :landing_page)
    association(:rewards, factory: :reward)
    before(:create) { |campaign| campaign.categories << Category.find(Category.first.id + Random.rand(10)) }
    after(:create) { |campaign| campaign.paid! }
  end

  factory :landing_page do
    title         { Random.paragraphs(1) }
    sub_title     { Random.paragraphs(3) }
    body          { Random.paragraphs(10) }
  end
end