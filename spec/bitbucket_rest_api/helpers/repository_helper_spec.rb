# encoding: UTF-8
require 'bitbucket_rest_api'

describe "RepositoryHelper" do
  context "#sanitize_repository_name" do
    include BitBucket::Helpers::RepositoryHelper

    it "filters special characters" do
      expect(sanitize_repository_name("Funnü ChAraxt%")).to eq("funn-charaxt")
    end

    it "filters special characters" do
      expect(sanitize_repository_name(nil)).to eq(nil)
    end

    it "replaces slashes by dashes" do
      expect(sanitize_repository_name("my/repo")).to eq("my-repo")
    end

    it "doesn't put more than one dash in a row" do
      expect(sanitize_repository_name("my - repo")).to eq("my-repo")
    end

    it "does not change a valid repo name" do
      ["bit.bucket", "bitbucket", "bit-bucket", "bit_bucket"].each do |repo_name|
        expect(sanitize_repository_name(repo_name)).to eq(repo_name)
      end
    end
  end
end
