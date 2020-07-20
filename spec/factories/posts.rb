FactoryBot.define do
  factory :post do
    title           { Faker::Hipster.sentence }
    content         { Faker::Hipster.paragraph }
    user            { create :user }
    ip              { Faker::Internet.ip_v4_address }
    avg_rating      { nil }
    rating_value    { 0 }
    rating_count    { 0 }
  end
end
