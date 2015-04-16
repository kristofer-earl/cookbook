include_recipe 'spiral::tomcat8'

directory '/var/log/httpsrv' do
  owner 'tomcat'
  group node['spiral']['users']['group']
  mode '0755'
  action :create  
end
