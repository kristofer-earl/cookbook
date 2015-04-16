include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'python'
include_recipe 'supervisor'
include_recipe 'spiral::default'

dl_location = "/opt/activemq-#{node['spiral']['activemq']['version']}-bin.tar.gz"
activemq_path = "/opt/activemq"

remote_file dl_location do
  source node['spiral']['activemq']['url']
  not_if { ::File.exists?(dl_location) }
end

execute 'activemq_extract' do
  command "tar xzf #{dl_location} -C /opt"
  not_if { ::File.exists?("/opt/apache-activemq-#{node['spiral']['activemq']['version']}") }
end

link activemq_path do
  to "/opt/apache-activemq-#{node['spiral']['activemq']['version']}"
  not_if { ::File.exists?(activemq_path) }
end

execute 'activemq_chown' do
  command "chown -R activemq:#{node['spiral']['users']['group']} #{activemq_path}/"
  action :run
end

supervisor_service 'activemq' do
  action :enable
  autostart true
  user 'activemq'
  environment 'HOME' => activemq_path, 'JAVA_OPTS' => "#{node['spiral']['activemq']['java_opts']}"
  command "#{activemq_path}/bin/activemq console"
end
