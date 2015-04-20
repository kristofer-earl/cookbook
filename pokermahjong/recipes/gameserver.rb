include_recipe 'spiral::gameserver'

package 'maven'
package 'ant'

src_path = '/opt/src'

directory src_path do
  owner 'root'
  group node['spiral']['users']['group']
  mode '0755'
  action :create
end

git "#{src_path}/gameserver" do
  repository node[:gameserver][:git_repository]
  revision node[:gameserver][:revision]
  action :sync
  #notifies :run, "bash[compile_gameserver]"
end

template "#{src_path}/gameserver/GameServer/src/main/config/facebook_staging/game_server.properties" do
  source 'facebook_staging/gameserver/game_server.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create 
end

template "#{src_path}/gameserver/ServerCore/src/main/config/facebook_staging/application.properties" do
  source 'facebook_staging/servercore/application.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end
