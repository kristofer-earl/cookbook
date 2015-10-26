include_recipe 'percona::client'
include_recipe 'spiral::phpfpm'

directory '/srv/http' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

%w{livezilla-6-en livezilla-6-jp livezilla-6-id}.each do |dir|
  directory "/srv/http/#{dir}" do
    owner 'www-data'
    group 'www-data'
    mode  '0755'
    action :create
  end
end

directory '/srv/http/livezilla-6-jp' do
  owner 'www-data'
  group 'www-data'
  mode  '0755'
  action :create
end

directory '/srv/http/livezilla-6-id' do
  owner 'www-data'
  group 'www-data'
  mode  '0755'
  action :create
end

%w{en jp id}.each do |dir|
  directory "/var/log/nginx/#{dir}" do
    owner 'www-data'
    group 'www-data'
    mode  '0755'
    action :create
  end
end

%w{access-en.log error-en.log}.each do |file|
  file "/var/log/nginx/en/#{file}" do
    owner 'www-data'
    group 'adm'
    mode '0640'
    action :create_if_missing
  end
end

file '/var/log/nginx/jp/access-jp.log' do
  owner 'www-data'
  group 'adm'
  mode '0640'
  action :create_if_missing
end

file '/var/log/nginx/jp/error-jp.log' do
  owner 'www-data'
  group 'adm'
  mode '0640'
  action :create_if_missing
end

file '/var/log/nginx/id/access-id.log' do
  owner 'www-data'
  group 'adm'
  mode '0640'
  action :create_if_missing
end

file '/var/log/nginx/id/error-id.log' do
  owner 'www-data'
  group 'adm'
  mode '0640'
  action :create_if_missing
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

mount '/srv/http' do
  device 'lz-w88-nfs1.localdomain:/srv/http'
  fstype 'nfs'
  options 'rw'
  action [:mount, :enable]
end
