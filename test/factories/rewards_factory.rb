# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reward do
    initial_stock       5
    points              25
    association(:product, factory: :product)
  end
end
