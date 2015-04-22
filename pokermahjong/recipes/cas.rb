include_recipe 'pokermahjong::default'
include_recipe 'spiral::nginx'
include_recipe 'spiral::tomcat'
include_recipe 'spiral::default'

tomcat_path = '/opt/tomcat'

git "#{node['pokermahjong']['src_path']}/httpsrv" do
  repository node[:git][:cas][:repository]
  revision node[:git][:cas][:revision]
  action :sync
end

directory node['pokermahjong']['cas']['log_path'] do
  owner 'tomcat'
  group node['spiral']['users']['group']
  mode '0755'
  action :create  
end
