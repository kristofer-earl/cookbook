include_recipe 'percona::client'
include_recipe 'spiral::phpfpm'

directory '/srv/http' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/livezilla-6-en' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/livezilla-6-jp' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/livezilla-6-id' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

cookbook_file '/etc/nginx/sites-available/livezilla-en.conf' do
  source   'lz-w88-en.conf'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

cookbook_file '/etc/nginx/sites-available/livezilla-jp.conf' do
  source   'lz-w88-jp.conf'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

cookbook_file '/etc/nginx/sites-available/livezilla-id.conf' do
  source   'lz-w88-id.conf'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/livezilla-en.conf' do
  to '/etc/nginx/sites-available/livezilla-en.conf'
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/livezilla-jp.conf' do
  to '/etc/nginx/sites-available/livezilla-jp.conf'
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/livezilla-id.conf' do
  to '/etc/nginx/sites-available/livezilla-id.conf'
  notifies :restart, "service[nginx]"
end
