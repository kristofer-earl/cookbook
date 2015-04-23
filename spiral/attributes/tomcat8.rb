default['spiral']['tomcat8']['series'] = '8' 
default['spiral']['tomcat8']['version'] = '8.0.21'

default['spiral']['tomcat8']['url'] = "http://apache.mirrors.pair.com/tomcat/tomcat-#{node['spiral']['tomcat8']['series']}/v#{node['spiral']['tomcat8']['version']}/bin/apache-tomcat-#{node['spiral']['tomcat8']['version']}.tar.gz"

default['spiral']['tomcat8']['java_opts'] = '-Xmx2048m -Xms512m -XX:MaxPermSize=512m'
