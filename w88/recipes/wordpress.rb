include_recipe 'percona::client'
include_recipe 'spiral::phpfpm'

mount '/srv' do
  device "#{node['nfs']['server']}:#{node['nfs']['share']}" 
  fstype 'nfs'
  options 'rw,async'
  action [:mount, :enable]
end

%w[ /srv/http /srv/http/wordpress ].each do |path|
  directory path do
    owner 'www-data'
    group 'www-data'
    mode  '0774'
    action :create
  end
end

link '/var/www' do
  to '/srv/http/wordpress'
end

cookbook_file '/etc/nginx/sites-available/w88info.com-nginx.conf' do
  source   'w88info.com-nginx.conf'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/w88info.com-nginx.conf' do
  to '/etc/nginx/sites-available/w88info.com-nginx.conf'
  notifies :restart, "service[nginx]"
end
