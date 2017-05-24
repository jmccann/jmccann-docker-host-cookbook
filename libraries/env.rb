module ChefDocker
  #
  # Methods for generating docker container ENV from
  # node attributes and/or secrets
  #
  module Env
    def docker_env(parent_attr, secret_keys = nil, vault = nil)
      env = parent_attr.map do |k, v|
        v = v.to_json if v.is_a?(Hash)
        "#{k.upcase}=#{v}"
      end

      if !secret_keys.nil? && !vault.nil?
        secret_keys.each do |item|
          env = override_secret(env, vault, item)
        end
      end

      env
    end

    #
    # Override attribute secrets if in Vault or DataBag
    #
    def override_secret(current_env, vault, item)
      return current_env unless secret_exist?(vault, item)

      Chef::Log.info("Loading secret '#{vault}/#{item}' ...")
      secret = chef_vault_item(vault, item)[item]
      current_env.delete_if { |env| env =~ /#{item.upcase}=/ }.push("#{item.upcase}=#{secret}")
    rescue ChefVault::Exceptions::SecretDecryption
      Chef::Log.warn "Could not load secret for '#{vault}/#{item}' (ChefVault::Exceptions::SecretDecryption)"
      current_env
    end

    #
    # Check if secret exists in Vault or DataBag
    #
    def secret_exist?(vault, item)
      Chef::DataBag.list.keys.include?(vault) && Chef::DataBag.load(vault).keys.include?(item)
    end
  end
end

Chef::Recipe.send(:include, ChefDocker::Env)
DockerCookbook::DockerContainer.send(:include, ChefDocker::Env)
