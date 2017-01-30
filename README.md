# docker-host

Utilizes the docker cookbook libraries to install a docker host.

I just got tired of including same code in multiple cookbooks.

## Supported Platforms

Tested And Validated On
- Ubuntu 16.04

## Usage

TODO: Include usage patterns of any providers or recipes.

### Recipe docker-host::default

Include `docker-host` in your run_list to install docker.

```json
{
  "run_list": [
    "recipe[docker-host::default]"
  ]
}
```

### Library docker_env

Use `docker_env` to configure a container from attributes/databags/vaults.

```ruby
docker_container 'drone' do
  repo 'drone/drone'
  tag 'latest'
  port '80:8000'
  env docker_env(node['test']['env']['drone']['config'], ['supersecret'], 'vault_env')
  restart_policy 'always'
  sensitive true
end
```

## Testing

* Linting - Cookstyle and Foodcritic
* Spec - ChefSpec
* Integration - Test Kitchen

Testing requires [ChefDK](https://downloads.chef.io/chef-dk/) be installed using it's native gems.

```
foodcritic -f any -X spec .
cookstyle
rspec --color --format progress
```

If you run into issues testing please first remove any additional gems you may
have installed into your ChefDK environment.  Extra gems can be found and removed
at `~/.chefdk/gem`.

## License and Authors

Author:: Jacob McCann (<jacob.mccann2@target.com>)

```text
Copyright (c) 2017 Jacob McCann, All Rights Reserved.
```
