#
# Cookbook Name:: jmccann-docker-host
# Spec:: default
#
# Copyright (c) 2017 Jacob McCann, All Rights Reserved.

require 'spec_helper'

describe 'jmccann-docker-host::default' do
  context 'When all attributes are default, on ubuntu' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    before do
      stub_command("docker info | grep 'Storage Driver: aufs'").and_return false
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'installs default docker version' do
      expect(chef_run).to create_docker_installation_package('default').with(version: '17.05.0')
    end

    it 'configures docker host default to socket' do
      expect(chef_run).to start_docker_service_manager('default').with(host: ['unix:///var/run/docker.sock'])
    end

    it 'configures the docker storage driver default to aufs' do
      expect(chef_run).to start_docker_service_manager('default').with(storage_driver: ['aufs'])
    end
  end

  context 'When all attributes are default, on centos' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.2') do |node, _server|
        # Need devicemapper for centos
        node.override['jmccann-docker-host']['docker']['service']['storage_driver'] = 'devicemapper'
      end
      runner.converge(described_recipe)
    end

    before do
      stub_command("docker info | grep 'Storage Driver: devicemapper'").and_return false
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'installs docker' do
      expect(chef_run).to create_docker_installation_package('default').with(version: '17.05.0')
    end

    it 'configures docker host default to socket' do
      expect(chef_run).to start_docker_service_manager('default').with(host: ['unix:///var/run/docker.sock'])
    end

    it 'configures the docker storage driver default to aufs' do
      expect(chef_run).to start_docker_service_manager('default').with(storage_driver: ['devicemapper'])
    end
  end
end
