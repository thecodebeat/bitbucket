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

    it "replaces slashes by dashes" do
      sanitize_repository_name("my/repo").should == "my-repo"
    end

    it "doesn't put more than one dash in a row" do
      sanitize_repository_name("my - repo").should == "my-repo"
    end

    ["bit.bucket", "bitbucket", "bit-bucket", "bit_bucket"].each do |repo_name|
      it "does not change a valid repo name (#{repo_name})" do
        sanitize_repository_name(repo_name).should == repo_name
      end
    end
  end
end
