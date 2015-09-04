include_recipe 'spiral::default'

execute 'add_nginx_repo' do
  command 'echo "deb http://sw-ubuntu-deb.s3.amazonaws.com /" > /etc/apt/sources.list.d/nginx.list && apt-get update'
  creates '/etc/apt/sources.list.d/nginx.list'
end

apt_package 'nginx-full' do
  version node['spiral']['nginx']['version'] 
  options '--force-yes' 
end

cookbook_file '/etc/nginx/nginx.conf' do
  source 'nginx-server.conf'
  notifies :restart, 'service[nginx]'
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
