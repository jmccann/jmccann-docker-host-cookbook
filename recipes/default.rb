#
# Cookbook Name:: jmccann-docker-host
# Recipe:: default
#
# Copyright (c) 2017 Jacob McCann, All Rights Reserved.

include_recipe 'chef-vault::default'

docker_installation_package 'default' do
  version node['jmccann-docker-host']['docker']['install']['version'] if node['jmccann-docker-host']['docker']['install']['version']
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
