include_recipe 'pokermahjong::default'
include_recipe 'spiral::tomcat'
include_recipe 'spiral::default'

tomcat_path = '/opt/tomcat'

git "#{node['pokermahjong']['src_path']}/pmbo" do
  repository node[:git][:pmbo][:repository]
  revision node[:git][:pmbo][:revision]
  action :sync
end

template "#{node['pokermahjong']['src_path']}/pmbo/src/main/config/facebook_staging/application.properties" do
  source 'facebook_staging/pmbo/application.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

directory node['pokermahjong']['pmbo']['log_path'] do
  owner 'tomcat'
  group node['spiral']['users']['group']
  mode '0755'
  action :create  
end
