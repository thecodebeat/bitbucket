# encoding: UTF-8
require 'bitbucket_rest_api'

describe BitBucket::Repos::Keys do
  it "creates a hook for a repository with special characters" do
    repository_name = "Funnü ChAraxt%"
    repository_url_name = "funn-charaxt"
    keys = BitBucket::Repos::Keys.new
    keys.should_receive(:post_request).with "/repositories/user/#{repository_url_name}/deploy-keys/", anything
    keys.create "user", repository_name, label: '', key: ''
  end
end