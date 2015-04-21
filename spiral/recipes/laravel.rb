include_recipe 'apt'
include_recipe 'hhvm3'
include_recipe 'spiral::nginx'

cookbook_file '/etc/nginx/sites-available/laravel_nginx.conf' do
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
