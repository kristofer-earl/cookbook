include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'python'
include_recipe 'supervisor'
include_recipe 'spiral::default'

dl_location = "/opt/tomcat-#{node['spiral']['tomcat8']['version']}.tar.gz"
tomcat_path = "/opt/tomcat8"

remote_file dl_location do
  source node['spiral']['tomcat8']['url']
  not_if { ::File.exists?(dl_location) }
end

execute 'tomcat8_extract' do
  command "tar xzf #{dl_location} -C /opt"
  not_if { ::File.exists?("/opt/apache-tomcat-#{node['spiral']['tomcat8']['version']}") }
end

link tomcat_path do
  to "/opt/apache-tomcat-#{node['spiral']['tomcat8']['version']}"
  not_if { ::File.exists?(tomcat_path) }
end

execute 'tomcat8_chown' do
  command "chown -R tomcat:#{node['spiral']['users']['group']} #{tomcat_path}/"
  action :run
end

supervisor_service 'tomcat8' do
  action :enable
  autostart true
  user 'tomcat8'
  environment 'HOME' => tomcat_path, 'JAVA_OPTS' => "#{node['spiral']['tomcat8']['java_opts']}"
  command "#{tomcat_path}/bin/catalina.sh run"
end
