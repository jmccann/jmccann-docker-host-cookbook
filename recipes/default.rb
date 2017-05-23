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
