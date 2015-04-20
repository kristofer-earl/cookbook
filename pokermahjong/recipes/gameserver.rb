include_recipe 'spiral::gameserver'

package 'maven'
package 'ant'

src_path = '/opt/deploy/gameserver'

directory src_path do
  owner 'root'
  group node['spiral']['users']['group']
  mode '0755'
  action :create
end

git src_path do
  repository node[:gameserver][:git_repository]
  revision node[:gameserver][:revision]
  action :sync
  #notifies :run, "bash[compile_gameserver]"
end
