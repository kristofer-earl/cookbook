include_recipe 'zabbix::default'

package 'zabbix-agent'

template  '/usr/lib/zabbix/externalscripts/zbx_nginx_stats.py' do
  mode   '0755'
  owner  'root'
  group  'root'
  action :create
  backup false
  source 'zbx_nginx_stats.py.erb'
  action :create
end
