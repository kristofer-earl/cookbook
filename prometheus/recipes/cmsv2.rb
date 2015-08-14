include_recipe 'spiral::phpfpm'
include_recipe 'prometheus::default'

cookbook_file 'cms-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys.cms'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end

bash 'insert_line_cmsv2' do
  user 'deploy'
  code <<-EOS
    cat /home/deploy/.ssh/authorized_keys.cms >> /home/deploy/.ssh/authorized_keys
  EOS
  not_if 'grep -q "prometheus-cms2.key" /home/deploy/.ssh/authorized_keys'
end

directory '/srv/http/cmsv2' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/cmsv2/shared' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/cmsv2/shared/config' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

template '/etc/nginx/sites-available/cmsv2.conf' do
  source   'cmsv2-nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/cmsv2.conf' do
  to '/etc/nginx/sites-available/cmsv2.conf'
  notifies :restart, 'service[nginx]'
end

directory '/srv/http/cmsv2/shared' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end
