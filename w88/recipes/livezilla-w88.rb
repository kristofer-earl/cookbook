include_recipe 'percona::client'
include_recipe 'spiral::phpfpm'

directory '/srv/http' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

mount '/srv/http' do
  device 'lz-w88-nfs1.localdomain:/srv/http'
  fstype 'nfs'
  options 'rw'
  action [:mount, :enable]
end

%w{livezilla-6-en livezilla-6-jp livezilla-6-id}.each do |dir|
  directory "/srv/http/#{dir}" do
    owner 'www-data'
    group 'www-data'
    mode  '0755'
    action :create
  end
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

%w{access-jp.log error-jp.log}.each do |file|
  file "/var/log/nginx/jp/#{file}" do
    owner 'www-data'
    group 'adm'
    mode '0640'
    action :create_if_missing
  end
end

%w{access-id.log error-id.log}.each do |file|
  file '/var/log/nginx/id/#{file}' do
    owner 'www-data'
    group 'adm'
    mode '0640'
    action :create_if_missing
  end
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

%w{livezilla-en.conf livezilla-jp.conf livezilla-id.conf}.each do |nginx.conf|
  link "/etc/nginx/sites-enabled/#{nginx.conf}" do
    to "/etc/nginx/sites-available/#{nginx.conf}"
    notifies :restart, "service[nginx]"
  end
end

