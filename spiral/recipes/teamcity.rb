include_recipe 'spiral::tomcat'

log_folder = '/logs'

remote_file '/opt/tomcat/webapps/TeamCity.war' do
  source 'http://download.jetbrains.com/teamcity/TeamCity-9.0.3.war'
end

link log_folder do
  to '/opt/tomcat/logs'
  not_if { ::File.exists?(log_folder) }
end

directory '/home/tomcat' do
  owner 'tomcat'
  group 'tomcat'
  mode  '0755'
  action :create
end

#Commenting it out to test the LB
#template '/etc/nginx/sites-enabled/teamcity' do
##  verify "nginx -t -c %{path}"
#  action :create
#  owner 'root'
#  group 'root'
#  mode '0755'
#  notifies :restart, "service[nginx]"
#end

#file '/etc/nginx/sites-enabled/default' do
#  action :delete
#  notifies :restart, "service[nginx]"
#end
