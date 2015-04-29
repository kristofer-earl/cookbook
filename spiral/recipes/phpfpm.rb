include_recipe 'spiral::nginx'
include_recipe 'spiral::newrelic'

package 'php5-fpm'
package 'php5-mysql'
package 'newrelic-php5'

cookbook_file '/etc/nginx/sites-available/default' do
  owner 'root'
  group 'root'
  mode  '0644'
  source 'nginx-default.conf'
  action :create
  notifies :creaddte, 'link[/etc/nginx/sites-enabled/default]', :immediately
  notifies :reload, 'service[nginx]', :delayed
end

link "/etc/nginx/sites-enabled/default" do
  to "/etc/nginx/sites-available/default"
end

service 'php5-fpm' do
  supports :restart => true, :reload => false
  action :enable
end

cookbook_file '/etc/php5/fpm/php.ini' do
  owner 'root'
  group 'root'
  mode  '0644'
  source 'php-fpm.ini'
  action :create
  notifies :restart, 'service[php5-fpm]', :delayed
end

echo newrelic-php5 newrelic-php5/application-name string "My Application Name" | debconf-set-selections
echo newrelic-php5 newrelic-php5/license-key string "0123456789abcdef0123456789abcdef01234567" | debconf-set-selections

bash "debconf_newrelic" do
  user "root"
  code <<-EOS
  echo newrelic-php5 newrelic-php5/license-key string #{node[:newrelic][:license_key]} | debconf-set-selections
  echo newrelic-php5 newrelic-php5/application-name string #{node[:newrelic][:app_name_prefix]}_#{node[:opsworks][:instance][:hostname]} | debconf-set-selections
  EOS
end
