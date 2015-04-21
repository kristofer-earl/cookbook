include_recipe 'spiral::default'
include_recipe 'pokermahjong::default'
include_recipe 'supervisor'

package 'maven'
package 'ant'

src_path = '/opt/src'
log_path = '/var/log/gs'



directory src_path do
  owner 'root'
  group node['spiral']['users']['group']
  mode '0755'
  action :create
end

git "#{src_path}/lobby" do
  repository node[:git][:repository]
  revision node[:git][:revision]
  action :sync
  #notifies :run, "bash[compile_lobby]"
end

template "#{src_path}/lobby/LobbyServer/src/main/config/facebook_staging/lobby_server.properties" do
  source 'facebook_staging/lobby/lobby_server.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create 
end

template "#{src_path}/lobby/ServerCore/src/main/config/facebook_staging/application.properties" do
  source 'facebook_staging/servercore/application.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

execute 'setup_server_core' do
  cwd     "#{src_path}/lobby/ServerCore"
  command 'mvn -f pom_base.xml install'
end

execute 'compile_server_core' do
  cwd     "#{src_path}/lobby/ServerCore"
  command 'mvn install -DskipTests=true -Pfacebook_staging'
end

execute 'compile_lobby' do
  cwd     "#{src_path}/lobby/LobbyServer"
  command 'mvn package -Dmaven.test.skip=true -Pfacebook_staging'
end

directory '/opt/lobby' do
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

execute 'install_lobby' do
  cwd     "#{src_path}/lobby/LobbyServer/target"
  command 'install -m755 LobbyServer-1.0-SNAPSHOT-jar-with-dependencies.jar /opt/gs/lobby.jar'
end

directory log_path do
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{log_path}/logback.properties" do
  source 'logback.properties.erb'
  action :create
  owner  'root'
  group  'root'
  mode   '0755'
end

supervisor_service 'lobby' do
  action :enable
  autostart true
  user 'root'
  directory log_path
  environment 'HOME' => log_path
  command "java #{node['spiral']['lobby']['java_opts']} -jar /opt/lobby/lobby.jar"
end
