include_recipe 'spiral::nginx'
include_recipe 'spiral::newrelic'

package 'php5-cli'
package 'php5-fpm'
package 'php5-mcrypt'
package 'php5-mysql'
package 'newrelic-php5'

directory '/srv/http' do
  owner 'deploy'
  group 'www-data'
  mode  '0766'
  action :create
end

service 'php5-fpm' do
  supports :restart => true, :reload => false
  action :enable
end

bash "debconf_newrelic" do
  user "root"
  code <<-EOS
  echo newrelic-php5 newrelic-php5/license-key string #{node[:newrelic][:license_key]} | debconf-set-selections
  echo newrelic-php5 newrelic-php5/application-name string #{node['pokermahjong']['nr_app_name']} | debconf-set-selections
  EOS
end

package 'newrelic-php5'

cookbook_file '/etc/php5/fpm/php.ini' do
  owner 'root'
  group 'root'
  mode  '0644'
  source 'php-fpm.ini'
  action :create
  notifies :restart, 'service[php5-fpm]'
end

template '/etc/php5/mods-available/newrelic.ini' do
  source 'php5-newrelic.ini.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  action :create
  notifies :restart, 'service[php5-fpm]'
end

remote_file '/usr/local/bin/composer' do
  source 'https://getcomposer.org/composer.phar'
  owner  'root'
  group  'root'
  mode   '0755'
  not_if { ::File.exists?('/usr/local/bin/composer.phar') }
end

template '/etc/nginx/sites-available/php5-fpm-nginx.conf' do
  source   'php5-fpm-nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0755'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/php5-fpm-nginx.conf' do
  to '/etc/nginx/sites-available/php5-fpm-nginx.conf'
  notifies :restart, "service[nginx]"
end
