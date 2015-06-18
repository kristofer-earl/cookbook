include_recipe 'spiral::phpfpm'
include_recipe 'prometheus::default'

cookbook_file 'web-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys.web'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end

bash "insert_line" do
  user "deploy"
  code <<-EOS
    cat /home/deploy/.ssh/authorized_keys.web >> /home/deploy/.ssh/authorized_keys
  EOS
  not_if "grep -q 'prometheus-web.key' /home/deploy/.ssh/authorized_keys"
end

template '/etc/nginx/sites-available/web-nginx.conf' do
  source   'web-nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/web-nginx.conf' do
  to '/etc/nginx/sites-available/web-nginx.conf'
  notifies :restart, "service[nginx]"
end

directory '/srv/http/web' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/web/shared' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end


template '/srv/http/web/shared/.env' do
  source 'web.env.erb'
  owner  'deploy'
  group  'www-data'
  mode   '0644'
  action :create
end
