include_recipe 'prometheus::default'

cookbook_file 'api-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end

cookbook_file 'nginx-cors.conf' do
  path  '/etc/nginx/cors.conf'
  owner 'root'
  group 'root'
  mode  '0644'
  action :create
end

template '/etc/nginx/sites-available/api-nginx.conf' do
  source   'api-nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

directory '/srv/http/api' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/api/shared' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

template '/srv/http/api/shared/.env' do
  source 'api.env.erb'
  owner  'deploy'
  group  'www-data'
  mode   '0644'
  action :create
end

link '/etc/nginx/sites-enabled/api-nginx.conf' do
  to '/etc/nginx/sites-available/api-nginx.conf'
  notifies :restart, "service[nginx]"
end
