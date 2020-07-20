require File.expand_path '../spec_helper.rb', __FILE__

describe ".posts" do
  let(:url) { '/posts' }

  let(:params) do
    {
        title: Faker::Hipster.sentence,
        content: Faker::Hipster.paragraph,
        username: Faker::Name.name,
        ip: Faker::Internet.ip_v4_address
    }
  end

  let(:headers) do
    {
       'CONTENT_TYPE' => 'application/vnd.api+json',
       'ACCEPT' => 'application/vnd.api+json'
    }
  end


  context "with correct params" do
    it 'creates post' do
      response = post url, params, headers: headers
      expect(response.status).to eql(200)

      post = Post.find_by ip: params[:ip]
      expect(params[:title]).to eql(post.title)
      expect(params[:content]).to eql(post.content)
      expect(params[:ip]).to eql(post.ip.to_s)
    end

    it 'creates connection' do
      response = post url, params, headers: headers
      expect(response.status).to eql(200)

      connection = Connection.find_by ip: params[:ip]
      expect(connection).to be_truthy
    end
  end

  context "with incorrect params" do
    it 'return 422' do
   	  params[:ip] = '12345'
      response = post url, params, headers: headers
      expect(response.status).to eql(422)
    end
  end

  context "without some required params" do
    it 'creates post' do
   	  params.delete(:ip)
      response = post url, params, headers: headers
      expect(response.status).to eql(422)
    end

    it "doesn't create user" do
      user_amount = User.all.count
      post url, params: params.delete(:ip), headers: headers

      expect(User.all.count).to eql(user_amount)
    end
  end
end