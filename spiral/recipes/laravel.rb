include_recipe 'apt'
include_recipe 'hhvm3'
include_recipe 'spiral::nginx'


directory '/laravel' do
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

template '/etc/nginx/sites-available/laravel_nginx.conf' do
  source   'laravel_nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0755'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/laravel_nginx.conf' do
  to '/etc/nginx/sites-available/laravel_nginx.conf'
end
