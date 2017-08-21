module ChefDocker
  #
  # Methods for generating docker container ENV from
  # node attributes and/or secrets
  #
  module Env
    #
    # Read vault/item and convert data_bag to Hash and cleanup extra keys
    # @param vault [String] Vault to load data from
    # @param item [String] Vault Item to load data from
    # @return [Hash] return cleaned up Hash of Vault Item
    #
    def chef_vault_item_hash(vault, item)
      secret = chef_vault_item(vault, item).to_hash
      secret.delete('id')
      secret.delete('data_bag')
      secret.delete('chef_type')

      secret
    end

    #
    # Deep merge two Hashs
    # @param tgt [Hash] target hash that we will be **altering**
    # @param src [Hash] read from this source hash
    # @return the modified target hash
    # @note this one does not merge Arrays
    #
    def deep_merge(tgt_hash, src_hash)
      tgt_hash.merge(src_hash) do |_key, oldval, newval|
        if oldval.is_a?(Hash) && newval.is_a?(Hash)
          deep_merge(oldval, newval)
        else
          newval
        end
      end
    end

    def docker_env(parent_attr, secret_keys = nil, vault = nil)
      env = parent_attr.to_hash

      # Load/Overwrite secrets
      if !secret_keys.nil? && !vault.nil?
        secret_keys.each do |item|
          env = override_secret(env, vault, item)
        end
      end

      env_from_hash(env)
    end

    #
    # Convert a Hash to a docker env attr
    # @param h [Hash] Hash to convert to "environment"
    # @return [Array<String>] return an array of strings in keypair format, e.g. ["a=b, n=1"]
    #
    def env_from_hash(h)
      h.map do |k, v|
        v = v.to_json if v.is_a?(Hash)
        "#{k.upcase}=#{v}"
      end
    end

    #
    # Override attribute secrets if in Vault or DataBag
    #
    def override_secret(current_env, vault, item)
      return current_env unless secret_exist?(vault, item)

      Chef::Log.info("Loading secret '#{vault}/#{item}' ...")
      secret = chef_vault_item_hash(vault, item)
      deep_merge(current_env, secret)

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
