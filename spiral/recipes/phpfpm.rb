include_recipe 'spiral::nginx'
include_recipe 'spiral::users'

execute 'add_ondrej_php_ppa' do
  command '/usr/bin/apt-add-repository -y ppa:ondrej/php5-5.6; apt-get update'
end


package 'php5-cli'
package 'php5-fpm'
package 'php5-mcrypt'
package 'php5-mysql'
package 'php5-redis'
package 'php5-memcached'
package 'php5-gd'

directory '/srv/http' do
  owner  'deploy'
  group  'www-data'
  mode   '0774'
  action :create
end

directory '/srv/http/adm' do
  owner  'www-data'
  group  'www-data'
  mode   '0744'
  action :create
end

directory '/srv/http/adm/phpfpm-cache-clear' do
  owner  'www-data'
  group  'www-data'
  mode   '0744'
  action :create
end

cookbook_file '/srv/http/adm/phpfpm-cache-clear/index.php' do
  owner 'root'
  group 'root'
  mode  '0644'
  source 'phpfpm-cache-clear.php'
  action :create
end

cookbook_file '/etc/nginx/sites-available/phpfpm-cache-clear.conf' do
  owner 'root'
  group 'root'
  mode  '0644'
  source 'phpfpm-cache-clear.conf'
  action :create
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/phpfpm-cache-clear.conf' do
  to '/etc/nginx/sites-available/phpfpm-cache-clear.conf'
  notifies :restart, "service[nginx]"
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
  not_if { ::File.exists?('/usr/local/bin/composer') }
end
