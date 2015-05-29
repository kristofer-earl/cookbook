include_recipe 'prometheus::default'

cookbook_file 'api-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys.api'
  owner 'deploy'
 group 'www-data'
  mode  '0600'
  action :create
end

bash "insert_line" do
  user "deploy"
  code <<-EOS
    cat /home/deploy/.ssh/authorized_keys.api >> /home/deploy/.ssh/authorized_keys
  EOS
  not_if "grep -q 'prometheus-api.key' /home/deploy/.ssh/authorized_keys"
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

directory '/srv/http/api/shared/config' do
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

template '/srv/http/api/shared/config/cache.php' do
  source 'api-cache.php.erb'
  owner  'deploy'
  group  'www-data'
  mode   '0644'
  action :create
end

link '/etc/nginx/sites-enabled/api-nginx.conf' do
  to '/etc/nginx/sites-available/api-nginx.conf'
  notifies :restart, "service[nginx]"
end
