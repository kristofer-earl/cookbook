include_recipe 'apt'

apt_repository 'newrelic' do
  uri 'http://apt.newrelic.com/debian'
  distribution 'newrelic' 
  components ['non-free']
  key 'https://download.newrelic.com/548C16BF.gpg'
end

package 'newrelic-sysmond'

cookbook_file '/etc/newrelic/nrsysmond.cfg' do
  action :delete
end

template '/etc/newrelic/nrsysmond.cfg' do
  source 'nrsysmond.cfg.erb'
  owner  'root'
  group  'root'
  mode   '0744'
  action :create
end
