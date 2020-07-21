require File.expand_path 'spec_helper.rb', __dir__

describe '.ratings' do
  let(:url) { '/ratings' }
  let(:post) { create(:post) }

  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json'
    }
  end

  context 'with correct params' do
    it 'update ratings' do
      response = patch url, { post_id: post.id, value: 5 }, headers: headers
      expect(response.status).to eql(200)
    end
  end

  context 'with incorrect params' do
    it 'return 422' do
      response = patch url, { post_id: post.id, value: 6 }, headers: headers
      expect(response.status).to eql(422)
    end
  end
end
