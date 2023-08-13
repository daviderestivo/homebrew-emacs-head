class ResourcesResolver
  def self.get_resource_url(resource)
    base_url = "https://raw.githubusercontent.com"
    repo   = ENV['HOMEBREW_GITHUB_REPOSITORY']
    owner  = ENV['HOMEBREW_GITHUB_REPOSITORY_OWNER']
    branch = ENV['HOMEBREW_GITHUB_REF']

    if repo
      if branch
        # on a branch
        [base_url, owner, repo, branch.sub("refs/heads/", ""), resource].join("/")
      else
        # on master
        [base_url, owner, repo, "master", resource].join("/")
      end
    else
      # local run
      "file:///" + Dir.pwd + "/" + resource
    end
  end
end
