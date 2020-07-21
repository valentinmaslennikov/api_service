require File.expand_path 'spec_helper.rb', __dir__

describe '.ratings' do
  let(:url) { '/top' }
  let!(:posts) { create_list(:post, 15) }

  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/vnd.api+json',
      'ACCEPT' => 'application/vnd.api+json'
    }
  end

  context 'db has some posts' do
    it 'return 3' do
      response = get url, { count: 3 }, headers: headers
      expect(response.status).to eql(200)
      # expect(JSON.load(response.body)).to eql(response_body)
    end
  end

  context 'db has no posts' do
    it 'return nothing' do
      Post.destroy_all
      response = patch url, { count: 5 }, headers: headers
      expect(response.status).to eql(404)
    end
  end
end
