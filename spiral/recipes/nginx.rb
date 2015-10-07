include_recipe 'spiral::default'

cookbook_file '/etc/apt/sources.list.d/nginx.list' do
  source 'nginx.list'
  notifies :run, 'execute[apt-get update]', :immediately
  action :create
end

apt_package 'nginx-full' do
  version node['spiral']['nginx']['version'] 
  options '--force-yes' 
end

template '/etc/nginx/nginx.conf' do
  source 'nginx-server.conf.erb'
  notifies :restart, 'service[nginx]'
  backup 3
  action :create
end

cookbook_file '/etc/nginx/pagespeed.conf' do
  source 'nginx-pagespeed.conf'
  action :create
end

cookbook_file 'default' do
  path   '/etc/nginx/sites-enabled/default'
  notifies :restart, 'service[nginx]'
  action :delete
  manage_symlink_source true
end

directory '/var/log/nginx' do
  owner  'www-data'
  group  'www-data'
  mode   '0755'
  action :create
end

service 'nginx' do
  action :enable
  supports :status => true, :start => true, :stop => true, :restart => true
end
