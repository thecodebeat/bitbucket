# encoding: UTF-8
require 'bitbucket_rest_api'

describe BitBucket::Repos::Keys do
  context "creating a key" do
    let(:keys) { BitBucket::Repos::Keys.new }
    
    it "should work for a repository with special characters" do
      repository_name = "Funnü ChAraxt%"
      repository_url_name = "funn-charaxt"
      keys.should_receive(:post_request).with "/repositories/user/#{repository_url_name}/deploy-keys/", anything
      keys.create "user", repository_name, label: '', key: ''
    end
  
    it "should preserve dashes in the repository name" do
      repository_name = "my-repo"
      keys.should_receive(:post_request).with "/repositories/user/#{repository_name}/deploy-keys/", anything
      keys.create "user", repository_name, label: '', key: ''
    end
  end
end