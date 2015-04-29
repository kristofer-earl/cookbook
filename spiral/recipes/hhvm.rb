include_recipe 'apt'
include_recipe 'hhvm3'
include_recipe 'spiral::newrelic'
include_recipe 'spiral::nginx'


directory '/srv/http' do
  owner 'www-data'
  group 'www-data'
  mode  '0755'
  action :create
end

remote_file '/usr/share/composer.phar' do
  source 'https://getcomposer.org/composer.phar' 
  not_if { ::File.exists?('/usr/share/composer.phar') }
end

cookbook_file '/usr/local/bin/composer' do
  source 'composer.sh'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template '/etc/nginx/sites-available/hhvm_nginx.conf' do
  source   'hhvm_nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0755'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/hhvm_nginx.conf' do
  to '/etc/nginx/sites-available/hhvm_nginx.conf'
end

cookbook_file 'hhvm_server.ini' do
  path   '/etc/hhvm/server.ini'
  owner  'root'
  group  'root'
  action :create
  notifies :restart, "service[hhvm]"
end

execute 'laravel_installer' do
  command "composer global require 'laravel/installer#{node['laravel']['version']}'"
end
