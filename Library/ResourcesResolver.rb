class ResourcesResolver
  def self.get_resource_url(resource)
    base_url = "https://raw.githubusercontent.com"
    repo   = ENV['HOMEBREW_EMACS_HEAD_GITHUB_REPOSITORY']
    branch = ENV['HOMEBREW_EMACS_HEAD_GITHUB_REPOSITORY_REF']
    local_resources  = ENV['HOMEBREW_USE_LOCAL_RESOURCES']

    # GitHub CICD
    if repo
      if branch
        # On a branch
        [base_url, repo, branch.sub("refs/heads/", ""), resource].join("/")
      else
        # On master
        [base_url, repo, "master", resource].join("/")
      end
    # LOCAL
    else
      # Force use of local resources by setting HOMEBREW_USE_LOCAL_RESOURCES=1
      if local_resources
        # local run
        "file:///" + Dir.pwd + "/" + resource
      else
        [base_url, "daviderestivo", "homebrew-emacs-head", "master", resource].join("/")
      end
    end
  end
end
