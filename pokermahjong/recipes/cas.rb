include_recipe 'spiral::tomcat'

directory '/var/log/cas' do
  owner 'tomcat'
  group node['spiral']['users']['group']
  mode '0755'
  action :create  
end
