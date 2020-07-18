# server.rb
require 'sinatra'
require 'require_all'
require 'sinatra/activerecord'
require 'json'
require 'resolv'
require 'sinatra/param'
require_all './models'

set :bind, '0.0.0.0'
set :port, 8080
set :environment, :production

before do
  content_type :json
end

# Создать пост

post '/posts' do
	param :username, String
	param :title, String
	param :content, String
	param :ip, String, format: Resolv::IPv4::Regex

	user = User.find_or_create_by(username: params[:username])
	post = Post.create(title: params[:title], 
					   content: params[:content], 
					   user: user)
	connection = Connection.find_or_create_by(user: user, ip: params[:ip]) if post.persisted?

  	post.persisted? ? post.to_json : post.errors.to_json
end

# Поставить оценку посту
# TODO сообразить валидацию на цифру рейтинга

post '/ratings' do
	param :post_id, Integer
	param :value, Integer, within: 1..5

	Post.transaction do
		@post = Post.lock.find_by(id: params[:post_id])
		halt 404, { message: "Not found" }.to_json unless @post
        @post.rating_value = @post.rating_value + params[:value].to_i
        @post.rating_count = @post.rating_count.to_i.succ
        @post.avg_rating = (@post.rating_value / @post.rating_count).round(2)
		@post.save!
	end
	{awg_rating: @post.avg_rating}.to_json
end

# Получить топ N постов по среднему рейтингу.

get '/top' do
    posts = Post.order('avg_rating DESC NULLS LAST')
                .limit(params[:count])
                .pluck(:title, :content)
                .map { |values| Hash[%i[title content].zip(values)] }
    if posts.present?
    	posts.to_json
    else
    	halt 404, { message: "Not found" }.to_json
    end
end

# Получить список айпи, с которых постило несколько разных авторов.

get '/ips' do
	SQL = <<~SQL
		WITH temp_table AS (
			SELECT connections.ip, COUNT(DISTINCT users.id) FROM connections 
			LEFT OUTER JOIN users ON users.id = connections.user_id
			GROUP BY connections.ip HAVING COUNT(DISTINCT users.id) > 1
		) SELECT temp_table.ip, users.username FROM temp_table
		JOIN connections ON temp_table.ip = connections.ip
		JOIN users ON users.id = connections.user_id
	SQL

	result = ActiveRecord::Base.connection.execute(SQL).to_a.group_by{|i| i['ip']}.map do |i, v|
			{ip_address: i,
			usernames: v.map{|x| x['username']}}
	end

	if result.present?
		result.to_json
	else
		halt 404, { message: "Not found" }.to_json
	end
end

#shotgun --port=8080 app.rb
#bundle exec irb -I. -r app.rb