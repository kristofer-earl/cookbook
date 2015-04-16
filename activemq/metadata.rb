name             'activemq'
maintainer       'Opscode, Inc.'
maintainer_email 'cookbooks@opscode.com'
license          'Apache 2.0'
description      'Installs activemq and sets it up as service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.3.4'
source_url       "https://github.com/opscode-cookbooks/activemq"
issues_url       "https://github.com/opscode-cookbooks/activemq/issues"

%w(ubuntu debian redhat centos suse).each do |os|
  supports os
end

depends 'java', '~> 1.13'

