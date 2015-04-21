include_recipe 'spiral::nginx'
include_recipe 'spiral::tomcat8'

cookbook_file 'crossdomain.xml' do
  path '/usr/share/nginx/html/crossdomain.xml'
  owner 'www-data'
  group 'www-data'
  mode  '0755'
  action :create_if_missing 
end

cookbook_file 'nginx_httpsrv_reverse_proxy.conf' do
  path  '/etc/nginx/sites-available/httpsrv'
  owner 'root'
  group 'root'
  mode  '0755'
  action :create_if_missing
  notifies :restart, "service[nginx]" 
end

directory '/var/log/httpsrv' do
  owner 'tomcat'
  group node['spiral']['users']['group']
  mode '0755'
  action :create  
end
