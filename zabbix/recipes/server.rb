include_recipe 'spiral::phpfpm'
include_recipe 'zabbix::default'

package 'zabbix-server-mysql'
package 'zabbix-frontend-php'
package 'zabbix-get'

template '/etc/nginx/sites-available/zabbix-nginx.conf' do
  source   'zabbix-nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/zabbix-nginx.conf' do
  to '/etc/nginx/sites-available/zabbix-nginx.conf'
  notifies :restart, "service[nginx]"
end

template '/etc/zabbix/web/zabbix.conf.php' do
  source 'zabbix.webconf.php.erb'
  owner  'www-data'
  group  'www-data'
  mode   '0644'
  action :create
end
