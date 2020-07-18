require 'faker'

ActiveRecord::Base.transaction do

usernames = []
100.times { usernames << [Faker::Name.name].join }

ips = []
50.times { ips << Faker::Internet.ip_v4_address.to_s }

title = Faker::Hipster.sentence
content = Faker::Hipster.paragraph

  1.upto(200_500) do |i|
  	%x[curl --location --request POST '0.0.0.0:8080/posts' \
--form 'title=#{title}' \
--form 'content=#{content}' \
--form 'ip=#{ips.sample}' \
--form 'username=#{usernames.sample}']
    rand(0..5).times do
      %x[curl --location --request POST '0.0.0.0:8080/ratings' \
--form 'value=#{rand(1..5)}' \
--form 'post_id=#{i}']
    end
  end
end