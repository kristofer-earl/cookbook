include_recipe 'spiral::newrelic-java'
include_recipe 'pokermahjong::default'
include_recipe 'supervisor'

log_path = '/var/log/gs'

directory node['pokermahjong']['src_path'] do
  owner 'root'
  group node['spiral']['users']['group']
  mode '0755'
  action :create
end

git "#{node['pokermahjong']['src_path']}/gameserver" do
  repository node[:git][:pokermahjong][:repository]
  revision node[:git][:pokermahjong][:revision]
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

cookbook_file "#{node['pokermahjong']['src_path']}/insert_me.sql" do
  action :delete
end

rds_ip = Resolv.getaddress(node[:opsworks][:stack][:rds_instances].first[:address])

template "#{node['pokermahjong']['src_path']}/insert_me.sql" do
  source 'game_server_insert.sql.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

execute 'db_add_game_server' do
  command "mysql -u apmahjong -h #{rds_ip} --password='knphtansl~wrjiuopo4luagmu*opdob' < #{node['pokermahjong']['src_path']}/insert_me.sql"
end

supervisor_service 'gameserver' do
  action :enable
  autostart true
  user 'root'
  directory log_path
  environment 'HOME' => log_path
  command "java #{node['spiral']['gameserver']['java_opts']} -jar /opt/gs/gameserver.jar"
end
