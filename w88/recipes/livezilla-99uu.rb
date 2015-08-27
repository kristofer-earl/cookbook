include_recipe 'percona::client'
include_recipe 'spiral::phpfpm'

directory '/srv/http' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/livezilla' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

cookbook_file '/etc/nginx/sites-available/en-livezilla-nginx.conf' do
  source   'en-livezilla-nginx.conf'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

cookbook_file '/etc/nginx/sites-available/cn-livezilla-nginx.conf' do
  source   'cn-livezilla-nginx.conf'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/en-livezilla-nginx.conf' do
  to '/etc/nginx/sites-available/en-livezilla-nginx.conf'
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/cn-livezilla-nginx.conf' do
  to '/etc/nginx/sites-available/cn-livezilla-nginx.conf'
  notifies :restart, "service[nginx]"
end
