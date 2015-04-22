include_recipe 'pokermahjong::default'
include_recipe 'spiral::tomcat'
include_recipe 'spiral::default'

tomcat_path = '/opt/tomcat'

git "#{node['pokermahjong']['src_path']}/wallet" do
  repository node[:git][:wallet][:repository]
  revision node[:git][:wallet][:revision]
  action :sync
end

template "#{node['pokermahjong']['src_path']}/wallet/common/src/main/resources/jdbc.properties" do
  source 'wallet/jdbc.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{node['pokermahjong']['src_path']}/wallet/api/src/main/resources/log4j.properties" do
  source 'wallet/log4j.properties.api.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{node['pokermahjong']['src_path']}/wallet/backend/src/main/resources/cas.properties" do
  source 'wallet/cas.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{node['pokermahjong']['src_path']}/wallet/backend/src/main/resources/log4j.properties" do
  source 'wallet/log4j.properties.backend.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

execute 'compile_wallet' do
  cwd     "#{node['pokermahjong']['src_path']}/wallet/api"
  command 'mvn clean install -DskipTests=true'
end

execute 'install_wallet' do
  cwd     "#{node['pokermahjong']['src_path']}/wallet/api/target"
  command "install -m755 api.war #{tomcat_path}/webapps/api.war"
end

execute 'compile_walletbo' do
  cwd     "#{node['pokermahjong']['src_path']}/wallet/backend"
  command 'mvn clean install -DskipTests=true'
end

execute 'install_walletbo' do
  cwd     "#{node['pokermahjong']['src_path']}/wallet/backend/target"
  command "install -m755 backend.war #{tomcat_path}/webapps/backend.war"
end

directory node['pokermahjong']['wallet']['log_path'] do
  owner 'tomcat'
  group node['spiral']['users']['group']
  mode '0755'
  action :create  
end
