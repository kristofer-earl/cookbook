include_recipe 'pokermahjong::default'
include_recipe 'spiral::tomcat'
include_recipe 'spiral::default'

tomcat_path = '/opt/tomcat'

git "#{node['pokermahjong']['src_path']}/cas" do
  repository node[:git][:cas][:repository]
  revision node[:git][:cas][:revision]
  action :sync
end

template "#{node['pokermahjong']['src_path']}/cas/userbo/src/main/resources/cas.properties" do
  source 'cas/cas.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{node['pokermahjong']['src_path']}/cas/userbo/src/main/resources/jdbc.properties" do
  source 'cas/jdbc.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{node['pokermahjong']['src_path']}/cas/userbo/src/main/resources/log4j.properties" do
  source 'cas/log4j.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

template "#{node['pokermahjong']['src_path']}/cas/userbo/src/main/resources/com/kvxz/memcached/memcached.xml" do
  source 'cas/memcached.xml.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end

execute 'compile_casbo' do
  cwd     "#{node['pokermahjong']['src_path']}/cas/userbo"
  command 'mvn clean install -DskipTests=true'
end

execute 'install_casbo' do
  cwd     "#{node['pokermahjong']['src_path']}/cas/userbo/target"
  command "install -m755 userbo.war #{tomcat_path}/webapps/userbo.war"
end

execute 'compile_casfo' do
  cwd     "#{node['pokermahjong']['src_path']}/cas/userfo"
  command 'mvn clean install -DskipTests=true'
end

execute 'install_casfo' do
  cwd     "#{node['pokermahjong']['src_path']}/cas/userfo/target"
  command "install -m755 userfo.war #{tomcat_path}/webapps/userfo.war"
end

directory node['pokermahjong']['cas']['log_path'] do
  owner 'tomcat'
  group node['spiral']['users']['group']
  mode '0755'
  action :create  
end

supervisor_service 'tomcat' do
  action :restart
end
