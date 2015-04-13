include_recipe 'apt'
include_recipe 'spiral::default'

dl_location = "/opt/tomcat-#{node['spiral']['tomcat']['version']}.tar.gz"
tomcat_path = "/opt/tomcat"

remote_file dl_location do
  source node['spiral']['tomcat']['url']
  not_if { ::File.exists?(dl_location) }
end

execute 'tomcat_extract' do
  command "tar xzf #{dl_location} -C /opt"
  not_if { ::File.exists?("/opt/apache-tomcat-#{node['spiral']['tomcat']['version']}") }
end

link tomcat_path do
  to "/opt/apache-tomcat-#{node['spiral']['tomcat']['version']}"
  not_if { ::File.exists?(tomcat_path) }
end

execute 'tomcat_chown' do
  command "chown -R tomcat:#{node['spiral']['users']['group']} #{tomcat_path}/"
  action :run
end

supervisor_service 'tomcat' do
  action :enable
  autostart true
  user 'tomcat'
  environment "HOME=\"/opt/tomcat\",JAVA_OPTS=\"#{node['spiral']['tomcat']['java_opts']\"",
  command "#{tomcat_path}/bin/catalina.sh run"
end
