include_recipe 'pokermahjong::default'
include_recipe 'spiral::nginx'
include_recipe 'spiral::tomcat8'
include_recipe 'spiral::default'

tomcat8_path = '/opt/tomcat8'
log_path = '/var/log/httpsrv'

git "#{node['pokermahjong']['src_path']}/httpsrv" do
  repository node[:git][:repository]
  revision node[:git][:revision]
  action :sync
  #notifies :run, "bash[compile_httpsrv]"
end

template "#{node['pokermahjong']['src_path']}/httpsrv/HttpServer/src/main/config/facebook_staging/application.properties" do
  source 'facebook_staging/httpserver/application.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{node['pokermahjong']['src_path']}/httpsrv/HttpServer/src/main/config/facebook_staging/wallet.properties" do
  source 'facebook_staging/httpserver/wallet.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{node['pokermahjong']['src_path']}/httpsrv/HttpServer/src/main/config/facebook_staging/payment.properties" do
  source 'facebook_staging/httpserver/payment.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{node['pokermahjong']['src_path']}/httpsrv/HttpServer/src/main/config/facebook_staging/logback.xml" do
  source 'facebook_staging/httpserver/logback.xml'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end


template "#{node['pokermahjong']['src_path']}/httpsrv/ServerCore/src/main/config/facebook_staging/application.properties" do
  source 'facebook_staging/servercore/application.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

execute 'setup_server_core' do
  cwd     "#{node['pokermahjong']['src_path']}/httpsrv/ServerCore"
  command 'mvn -f pom_base.xml install'
end

execute 'compile_lobby' do
  cwd     "#{node['pokermahjong']['src_path']}/httpsrv/HttpServer"
  command 'mvn package -Dmaven.test.skip=true -Pfacebook_staging'
end

execute 'install_lobby' do
  cwd     "#{node['pokermahjong']['src_path']}/httpsrv/HttpServer/target"
  command "install -m755 HttpServer.war #{tomcat8_path}/webapps/HttpServer.war" 
end

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

link '/etc/nginx/sites-enabled/httpsrv' do
  to '/etc/nginx/sites-available/httpsrv' 
end

directory '/var/log/httpsrv' do
  owner 'tomcat'
  group node['spiral']['users']['group']
  mode '0755'
  action :create  
end
