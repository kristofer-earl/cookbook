include_recipe 'spiral::default'
include_recipe 'pokermahjong::default'
include_recipe 'supervisor'

node['pokermahjong']['src_path'] = '/opt/src'
log_path = '/var/log/gs'

directory node['pokermahjong']['src_path'] do
  owner 'root'
  group node['spiral']['users']['group']
  mode '0755'
  action :create
end

git "#{node['pokermahjong']['src_path']}/gameserver" do
  repository node[:git][:repository]
  revision node[:git][:revision]
  action :sync
end

cookbook_file "#{node['pokermahjong']['src_path']}/gameserver/GameServer/src/main/config/facebook_staging/game_server.properties" do
  action :delete
end

template "#{node['pokermahjong']['src_path']}/gameserver/GameServer/src/main/config/facebook_staging/game_server.properties" do
  source 'facebook_staging/gameserver/game_server.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create 
end

cookbook_file "#{node['pokermahjong']['src_path']}/gameserver/ServerCore/src/main/config/facebook_staging/application.properties" do
  action :delete
end

template "#{node['pokermahjong']['src_path']}/gameserver/ServerCore/src/main/config/facebook_staging/application.properties" do
  source 'facebook_staging/servercore/application.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

execute 'setup_server_core' do
  cwd     "#{node['pokermahjong']['src_path']}/gameserver/ServerCore"
  command 'mvn -f pom_base.xml install'
end

execute 'compile_server_core' do
  cwd     "#{node['pokermahjong']['src_path']}/gameserver/ServerCore"
  command 'mvn install -DskipTests=true -Pfacebook_staging'
end

execute 'compile_gameserver' do
  cwd     "#{node['pokermahjong']['src_path']}/gameserver/GameServer"
  command 'mvn package -Dmaven.test.skip=true -Pfacebook_staging'
end

directory '/opt/gs' do
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

execute 'install_gameserver' do
  cwd     "#{node['pokermahjong']['src_path']}/gameserver/GameServer/target"
  command 'install -m755 GameServer-1.0-SNAPSHOT-jar-with-dependencies.jar /opt/gs/gameserver.jar'
end

directory log_path do
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

cookbook_file "#{log_path}/logback.properties" do
  action :delete
end

template "#{log_path}/logback.properties" do
  source 'logback.properties.erb'
  action :create
  owner  'root'
  group  'root'
  mode   '0755'
end

supervisor_service 'gameserver' do
  action :enable
  autostart true
  user 'root'
  directory log_path
  environment 'HOME' => log_path
  command "java #{node['spiral']['gameserver']['java_opts']} -jar /opt/gs/gameserver.jar"
end
