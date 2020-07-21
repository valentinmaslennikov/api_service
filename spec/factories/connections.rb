# frozen_string_literal: true

FactoryBot.define do
  factory :connection do
    user        { create :user }
    ip          { Faker::Internet.ip_v4_address }
  end
end
