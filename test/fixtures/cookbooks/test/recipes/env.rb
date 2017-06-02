docker_image 'drone' do
  repo 'drone/drone'
  tag 'latest'
end

docker_container 'drone' do
  repo 'drone/drone'
  tag 'latest'
  port '80:8000'
  env docker_env(node['test']['env']['drone']['config'], ['supersecret', 'deepsecret', 'json_path'], 'vault_env')
  restart_policy 'always'
  sensitive true
end
