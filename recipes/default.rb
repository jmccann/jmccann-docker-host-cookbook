#
# Cookbook Name:: docker-host
# Recipe:: default
#
# Copyright (c) 2017 Jacob McCann, All Rights Reserved.

include_recipe 'chef-vault::default'

# Required for aufs
package "linux-image-extra-#{node['kernel']['release']}" do
  only_if { node['docker-host']['docker']['service']['storage_driver'] == 'aufs' }
end

# Required for devicemapper storage driver
# https://github.com/docker/docker/issues/22381#issuecomment-215342747
docker_installation_script 'default' do
  only_if { ['centos', 'redhat', 'amazon', 'scientific', 'oracle', 'fedora'].include?(node['platform']) }
end

docker_installation_tarball 'default' do
  version node['docker-host']['docker']['install']['version']
  only_if { ['debian', 'ubuntu'].include?(node['platform']) }
end

docker_service_manager 'default' do
  node['docker-host']['docker']['service'].each do |k, v|
    send(k, v)
  end

  retries 1
  retry_delay 20
end
