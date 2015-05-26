include_recipe 'zabbix::default'

package 'zabbix-agent'

template  '/etc/zabbix/zbx_nginx_stats.py' do
  mode   '0755'
  owner  'root'
  group  'root'
  backup false
  source 'zbx_nginx_stats.py.erb'
  action :create
end

template '/etc/zabbix/zabbix_agentd.conf' do
  mode   '0644'
  owner  'root'
  group  'root'
  backup false
  source 'zabbix_agentd.conf.erb'
  action :create
end
