include_recipe 'spiral::nginx'
#include_recipe 'spiral::newrelic'
include_recipe 'spiral::users'

execute "add_php_apt_key" do
  command "/usr/bin/apt-key add /usr/share/keyrings/php.gpg && apt-get update"
  action :nothing
end

cookbook_file  "/usr/share/keyrings/php.gpg" do
  mode "0644"
  owner "root"
  group "root"
  action :create
  backup false
  source  "php.gpg"
  notifies :run, resources(:execute => "add_php_apt_key")
end

apt_repository 'ondrej-php5-5_6-trusty' do
  uri 'http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
end

package 'php5-cli'
package 'php5-fpm'
package 'php5-mcrypt'
package 'php5-mysql'
package 'php5-redis'
package 'php5-memcached'
package 'php5-gd'
#package 'newrelic-php5'

directory '/srv/http' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

service 'php5-fpm' do
  supports :restart => true, :reload => false
  restart_command "/usr/sbin/invoke-rc.d php5-fpm restart"
  start_command "/usr/sbin/invoke-rc.d php5-fpm start"
  stop_command "/usr/sbin/invoke-rc.d php5-fpm stop"
  action :enable
end

bash "debconf_newrelic" do
  user "root"
  code <<-EOS
  echo newrelic-php5 newrelic-php5/license-key string #{node[:newrelic][:license_key]} | debconf-set-selections
  echo newrelic-php5 newrelic-php5/application-name string #{node['pokermahjong']['nr_app_name']} | debconf-set-selections
  EOS
end

cookbook_file '/etc/php5/fpm/php.ini' do
  owner 'root'
  group 'root'
  mode  '0644'
  source 'php-fpm.ini'
  action :create
  notifies :restart, 'service[php5-fpm]'
end

template '/etc/php5/fpm/pool.d/www.conf' do
  source 'fpm-pool.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  action :create
  notifies :restart, 'service[php5-fpm]'
end

template '/etc/php5/mods-available/newrelic.ini' do
  source 'php5-newrelic.ini.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  action :delete
  notifies :restart, 'service[php5-fpm]'
end

remote_file '/usr/local/bin/composer' do
  source 'https://getcomposer.org/composer.phar'
  owner  'root'
  group  'root'
  mode   '0755'
  not_if { ::File.exists?('/usr/local/bin/composer.phar') }
end
