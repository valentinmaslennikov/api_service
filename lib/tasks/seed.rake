# frozen_string_literal: true

require 'faker'

namespace :seeds do
  desc 'fast seeds to db'
  task :seed do
    usernames = []
    100.times { usernames << [Faker::Name.name].join }

    ips = []
    50.times { ips << Faker::Internet.ip_v4_address.to_s }

    title = Faker::Hipster.sentence
    content = Faker::Hipster.paragraph

    def create_post(title, content, ip, username)
      user = User.find_or_create_by(username: username)
      @post = Post.create(title: title, content: content, ip: ip, user: user)
      Connection.find_or_create_by(user: user, ip: ip)
      rand(0..5).times do
        @post.rating_value = @post.rating_value + rand(1..5)
        @post.rating_count = @post.rating_count.to_i.succ
        @post.avg_rating = (@post.rating_value / @post.rating_count).round(2)
        @post.save!
      end
    end

    1.upto(142_391) do |_i|
      create_post(title, content, ips.sample, usernames.sample)
    end
  end
end
