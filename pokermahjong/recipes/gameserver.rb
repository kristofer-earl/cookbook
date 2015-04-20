include_recipe 'spiral::gameserver'

package 'maven'
package 'ant'

git "/opt/deploy/gameserver" do
  repository node[:gameserver][:git_repository]
  revision node[:gameserver][:revision]
  action :sync
  #notifies :run, "bash[compile_gameserver]"
end
