include_recipe 'spiral::nginx'
include_recipe 'spiral::newrelic'

package 'php5-fpm'
package 'php5-mysql'
package 'newrelic-php5'

service 'php5-fpm' do
  supports :restart => true, :reload => false
  action :enable
end

bash "debconf_newrelic" do
  user "root"
  code <<-EOS
  echo newrelic-php5 newrelic-php5/license-key string #{node[:newrelic][:license_key]} | debconf-set-selections
  echo newrelic-php5 newrelic-php5/application-name string #{node[:newrelic][:app_name_prefix]}_#{node[:opsworks][:instance][:hostname]} | debconf-set-selections
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

nginx-php5-fpm.conf

template '/etc/nginx/sites-available/nginx-php5-fpm.conf' do
  source   'nginx-php5-fpm.conf.erb'
  owner    'root'
  group    'root'
  mode     '0755'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/nginx-php5-fpm.conf' do
  to '/etc/nginx/sites-available/nginx-php5-fpm.conf'
  notifies :restart, "service[nginx]"
end
