directory '/var/log/wallet' do
  owner 'tomcat'
  group node['spiral']['users']['group']
  mode '0755'
  action :create  
end
