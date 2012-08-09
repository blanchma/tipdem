# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name              { Random.country }
    description       { Random.paragraphs[0...300]}
  end
end
