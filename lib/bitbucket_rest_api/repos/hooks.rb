# encoding: utf-8

module BitBucket
  class Repos::Hooks < API

    REQUIRED_KEY_PARAM_NAMES = %w[ description url active events ].freeze

    # List hooks
    #
    # = Examples
    #  bitbucket = BitBucket.new
    #  bitbucket.repos.hooks.list 'user-name', 'repo-name'
    #  bitbucket.repos.hooks.list 'user-name', 'repo-name' { |hook| ... }
    #
    def list(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = get_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Gets a single hook
    #
    # = Examples
    #  @bitbucket = BitBucket.new
    #  @bitbucket.repos.hooks.get 'user-name', 'repo-name', 109172378)
    #
    def get(user_name, repo_name, hook_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of(hook_id)
      normalize! params

      get_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks/#{hook_id}", params)
    end
    alias :find :get

    # Create a hook
    #
    # = Inputs
    # * <tt>:type</tt> - One of the supported hooks. The type is a case-insensitive value.
    #
    # = Examples
    #  bitbucket = BitBucket.new
    #  bitbucket.repos.hooks.create 'user-name', 'repo-name',
    #    "type"           => "Basecamp",
    #    "Password"       => "...",
    #    "Username"       => "...",
    #    "Discussion URL" => "..."
    #
    def create(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params
      assert_required_keys(REQUIRED_KEY_PARAM_NAMES, params)

      post_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks", params)
    end

    # Edit a hook
    #
    # = Inputs
    # * <tt>:type</tt> - One of the supported hooks. The type is a case-insensitive value.
    #
    # = Examples
    #  bitbucket = BitBucket.new
    #  bitbucket.repos.hooks.edit 'user-name', 'repo-name', 109172378,
    #    "type"           => "Basecamp",
    #    "Password"       => "...",
    #    "Username"       => "...",
    #    "Discussion URL" => "..."
    #
    def edit(user_name, repo_name, hook_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of(hook_id)

      normalize! params

      put_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks/#{hook_id}", params)
    end

    # Delete hook
    #
    # = Examples
    #  @bitbucket = BitBucket.new
    #  @bitbucket.repos.hooks.delete 'user-name', 'repo-name', 109172378
    #
    def delete(user_name, repo_name, hook_id, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of(hook_id)
      normalize! params

      delete_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks/#{hook_id}", params)
    end

  end # Repos::Keys
end # BitBucket
