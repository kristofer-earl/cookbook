include_recipe 'prometheus::default'

cookbook_file 'api-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end

template '/etc/nginx/sites-available/api-nginx.conf' do
  source   'api-nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0755'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/api-nginx.conf' do
  to '/etc/nginx/sites-available/api-nginx.conf'
  notifies :restart, "service[nginx]"
end
