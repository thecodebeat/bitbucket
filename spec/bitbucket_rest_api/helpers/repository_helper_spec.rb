# encoding: UTF-8
require 'bitbucket_rest_api'

describe "RepositoryHelper" do
  context "#sanitize_repository_name" do
    include BitBucket::Helpers::RepositoryHelper

    it "filters special characters" do
      sanitize_repository_name("Funnü ChAraxt%").should == "funn-charaxt"
    end

    it "filters special characters" do
      sanitize_repository_name(nil).should == nil
    end

    ["bit.bucket", "bitbucket", "bit-bucket", "bit_bucket"].each do |repo_name|
      it "does not change a valid repo name (#{repo_name})" do
        sanitize_repository_name(repo_name).should == repo_name
      end
    end
  end
end
