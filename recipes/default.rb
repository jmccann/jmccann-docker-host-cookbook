#
# Cookbook Name:: jmccann-docker-host
# Recipe:: default
#
# Copyright (c) 2017 Jacob McCann, All Rights Reserved.

include_recipe 'chef-vault::default'

docker_installation_package 'default' do
  package_version node['jmccann-docker-host']['docker']['install']['package_version'] unless node.to_hash.dig('jmccann-docker-host', 'docker', 'install', 'package_version').nil?
  version node['jmccann-docker-host']['docker']['install']['version'] unless node.to_hash.dig('jmccann-docker-host', 'docker', 'install', 'version').nil?
end

docker_service_manager 'default' do
  node['jmccann-docker-host']['docker']['service'].each do |k, v|
    send(k, v)
  end

  retries 1
  retry_delay 20
end

execute 'restart docker' do
  command 'exit 0'
  notifies :restart, 'docker_service_manager[default]', :immediate
  not_if "docker info | grep 'Storage Driver: #{node['jmccann-docker-host']['docker']['service']['storage_driver']}'"
end
