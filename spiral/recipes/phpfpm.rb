include_recipe 'spiral::nginx'
include_recipe 'spiral::newrelic'
include_recipe 'spiral::users'

package 'php5-cli'
package 'php5-fpm'
package 'php5-mcrypt'
package 'php5-mysql'
package 'php5-redis'
package 'php5-memcached'
package 'php5-gd'
package 'newrelic-php5'

directory '/srv/http' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

service 'php5-fpm' do
  supports :restart => true, :reload => false
  action :enable
end

link '/etc/php5/cli/conf.d/99-mcrypt.ini' do
  to '/etc/php5/mods-available/mcrypt.ini'
end

link '/etc/php5/fpm/conf.d/99-mcrypt.ini' do
  to '/etc/php5/mods-available/mcrypt.ini'
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