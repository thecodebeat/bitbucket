# encoding: UTF-8
require 'bitbucket_rest_api'

describe BitBucket::Repos::Keys do
  context "creating a key" do
    let(:keys) { BitBucket::Repos::Keys.new }

    it "should work for a repository with special characters" do
      repository_name = "Funnü ChAraxt%"
      repository_url_name = "funn-charaxt"
      expect(keys).to receive(:post_request).with("/1.0/repositories/user/#{repository_url_name}/deploy-keys/", anything)
      keys.create "user", repository_name, label: '', key: ''
    end

    it "should preserve dashes in the repository name" do
      repository_name = "my-repo"
      expect(keys).to receive(:post_request).with("/1.0/repositories/user/#{repository_name}/deploy-keys/", anything)
      keys.create "user", repository_name, label: '', key: ''
    end

    it "should preserve dots in the repository name" do
      repository_name = "my.repo"
      expect(keys).to receive(:post_request).with("/1.0/repositories/user/#{repository_name}/deploy-keys/", anything)
      keys.create "user", repository_name, label: '', key: ''
    end

    it "should preserve numbers in the repository name" do
      repository_name = "myrepo33"
      expect(keys).to receive(:post_request).with("/1.0/repositories/user/#{repository_name}/deploy-keys/", anything)
      keys.create "user", repository_name, label: '', key: ''
    end

    it "should preserve underscores in the repository name" do
      repository_name = "my_repo"
      expect(keys).to receive(:post_request).with("/1.0/repositories/user/#{repository_name}/deploy-keys/", anything)
      keys.create "user", repository_name, label: '', key: ''
    end
  end
end
