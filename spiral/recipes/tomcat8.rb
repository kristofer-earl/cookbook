include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'python'
include_recipe 'supervisor'
include_recipe 'spiral::default'

dl_location = "/opt/tomcat-#{node['spiral']['tomcat8']['version']}.tar.gz"
tomcat8_path = "/opt/tomcat8"

remote_file dl_location do
  source node['spiral']['tomcat8']['url']
  not_if { ::File.exists?(dl_location) }
end

execute 'tomcat8_extract' do
  command "tar xzf #{dl_location} -C /opt"
  not_if { ::File.exists?("/opt/apache-tomcat-#{node['spiral']['tomcat8']['version']}") }
end

link tomcat8_path do
  to "/opt/apache-tomcat-#{node['spiral']['tomcat8']['version']}"
  not_if { ::File.exists?(tomcat8_path) }
end

execute 'tomcat8_chown' do
  command "chown -R tomcat:#{node['spiral']['users']['group']} #{tomcat8_path}/"
  action :run
end

supervisor_service 'tomcat8' do
  action :enable
  autostart true
  user 'tomcat'
  environment 'HOME' => tomcat8_path, 'JAVA_OPTS' => "#{node['spiral']['tomcat8']['java_opts']}"
  command "#{tomcat8_path}/bin/catalina.sh run"
end
