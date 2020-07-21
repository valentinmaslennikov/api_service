require File.expand_path 'spec_helper.rb', __dir__

describe '.ratings' do
  let(:url) { '/ips' }
  let(:posts) { create_list(:post, 15) }

  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/vnd.api+json',
      'ACCEPT' => 'application/vnd.api+json'
    }
  end

  context 'db has some ips' do
    before do
      @ip = Faker::Internet.ip_v4_address
      @ip_sec = Faker::Internet.ip_v4_address
      @users = create_list(:user, 5)
      @users_sec = create_list(:user, 3)
      create_list(:connection, 20)
      @users.map { |i| Connection.create!(ip: @ip, user_id: i.id) }
      @users_sec.map { |i| Connection.create!(ip: @ip_sec, user_id: i.id) }
    end

    it 'update ratings' do
      response = get url, headers: headers
      expect(response.status).to eql(200)
      response_body = [{ 'ip_address' => @ip, 'usernames' => @users.map { |i| i.username } },
                       { 'ip_address' => @ip_sec, 'usernames' => @users_sec.map { |i| i.username } }]
      expect(JSON.load(response.body)).to eql(response_body)
    end
  end

  context 'db has no ips' do
    it 'return 422' do
      response = patch url, headers: headers
      expect(response.status).to eql(404)
    end
  end
end
