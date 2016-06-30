require 'bitbucket_rest_api'

describe BitBucket::Repos::Statuses do
  let(:repo_name) { 'wrath' }
  let(:sha) { '123456' }
  let(:state) { 'FAILED' }
  let(:key) { 'my-build-key' }
  let(:url) { 'http://somewhere/build' }

  let(:statuses) { described_class.new }

  before { allow(statuses).to receive(:post_request) }

  subject(:status_create) do
    statuses.create('khan', repo_name, sha, state, key, url, { 'extra-stuff' => 'hello'})
  end

  describe 'create' do
    it 'should send request if parameters are valid' do
      expect(statuses).to receive(:post_request).with("/2.0/repositories/khan/wrath/commit/123456/statuses/build",
        {
          "extra-stuff"=>"hello",
          "state"=> state,
          "key"=> key,
          "url"=> url
        },
        {:headers=>{"Content-Type"=>"application/json"}})

      status_create
    end

    it 'should sanitize_repository_name' do
      expect(statuses).to receive(:sanitize_repository_name).with(repo_name) { 'radio-edit' }
      expect(statuses).to receive(:post_request).with("/2.0/repositories/khan/radio-edit/commit/123456/statuses/build",
        anything,
        anything)

      status_create
    end

    it 'should validate presence of sha, state, key, url' do
      expect(statuses).to receive(:_validate_presence_of).with(sha, state, key, url)

      status_create
    end

  end
end
