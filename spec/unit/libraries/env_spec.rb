#
# Cookbook Name:: docker-host
# Spec:: env
#
# Copyright (c) 2017 Jacob McCann, All Rights Reserved.

require 'spec_helper'

describe 'docker-host::env' do
  context 'When all attributes are default, on ubuntu' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |_node, server|
        inject_databags server
      end
      runner.converge('test::env')
    end

    let(:docker_env) do
      chef_run.docker_container('drone').env
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'loads env from attributes' do
      expect(docker_env).to include('SOMETHING=test')
      expect(docker_env).to include('NEXT=test2')
    end

    it 'loads secret from attributes' do
      expect(docker_env).to include('SECRET=abcd1234')
    end

    it 'overrides secret from vault' do
      expect(docker_env).to include('SUPERSECRET=itsasecret')
    end
  end
end
