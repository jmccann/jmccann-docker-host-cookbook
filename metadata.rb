name             'docker-host'
maintainer       'Jacob McCann'
maintainer_email 'jacob.mccann2@target.com'
license          'all_rights'
description      'Installs/Configures a docker host'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/jmccann/docker-host-cookbook'
issues_url       'https://github.com/jmccann/docker-host-cookbook/issues'
version          '0.2.0'

depends 'chef-vault', '~> 2.1'
depends 'docker', '~> 2.9'

supports 'ubuntu', '>= 16.04'
