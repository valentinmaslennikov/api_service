require 'faker'
require 'uri'
require 'net/http'
require 'json'
ActiveRecord::Base.transaction do
  usernames = []
  100.times { usernames << [Faker::Name.name].join }

  ips = []
  50.times { ips << Faker::Internet.ip_v4_address.to_s }

  title = Faker::Hipster.sentence
  content = Faker::Hipster.paragraph

  POOL_SIZE = 8

  jobs = Queue.new

  1.upto(186_108) do |i|
    jobs.push i
  end

  create_post = URI('http://127.0.0.1:8080/posts')
  create_rating = URI('http://127.0.0.1:8080/ratings')

  workers = POOL_SIZE.times.map do
    Thread.new do
      while x = jobs.pop(true)
        http = Net::HTTP.new(create_post.host, create_post.port)
        request = Net::HTTP::Post.new(create_post)
        request['Content-Type'] = 'application/json'
        # request["Accept"] = "application/vnd.api+json"
        request.body = { title: title, content: content, ip: ips.sample, username: usernames.sample }.to_json
        response = http.request(request)
        post_id = JSON(response.read_body)['id']
        puts response.read_body

        rand(0..5).times do
          http = Net::HTTP.new(create_rating.host, create_rating.port)
          request = Net::HTTP::Patch.new(create_rating)
          request['Content-Type'] = 'application/vnd.api+json'
          # request["Accept"] = "application/vnd.api+json"
          # request.body = {value: rand(1..5).to_s, post_id: post_id.to_s}.to_json
          form_data = [['value', rand(1..5).to_s], ['post_id', post_id.to_s]]
          request.set_form form_data, 'multipart/form-data'
          response = http.request(request)
          puts response.read_body
        end
      end
    rescue ThreadError
    end
  end
  workers.map(&:join)
end
