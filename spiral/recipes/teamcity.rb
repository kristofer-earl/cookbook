include_recipe 'spiral::tomcat'

log_folder = '/opt/logs'

remote_file '/opt/tomcat/webapps/TeamCity.war'
  source 'http://download.jetbrains.com/teamcity/TeamCity-9.0.3.war'
end

link log_folder do
  to '/opt/tomcat/logs'
  not_if { ::File.exists?(log_folder) }
end
