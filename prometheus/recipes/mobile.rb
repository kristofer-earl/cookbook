include_recipe 'spiral::phpfpm'
include_recipe 'prometheus::default'

cookbook_file 'web-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys.web'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end

template '/etc/nginx/sites-available/mobile-nginx.conf' do
  source   'mobile-nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/mobile-nginx.conf' do
  to '/etc/nginx/sites-available/mobile-nginx.conf'
  notifies :restart, "service[nginx]"
end

directory '/srv/http/mobile' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end
