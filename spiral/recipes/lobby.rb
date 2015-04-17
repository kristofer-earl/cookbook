include_recipe 'spiral::default'
include_recipe 'supervisor'

log_path = '/var/log/lobby'

directory log_path do
  owner 'root'
  group 'root'
  mode '0755'
  action :create  
end

supervisor_service 'lobby' do
  action :enable
  autostart true
  user 'root'
  directory log_path
  environment 'HOME' => log_path
  command "java #{node['spiral']['lobby']['java_opts']} -jar /opt/lobby/lobby.jar" 
end
