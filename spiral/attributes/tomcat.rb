default['spiral']['tomcat']['series'] = '7' 
default['spiral']['tomcat']['version'] = '7.0.61'

default['spiral']['tomcat']['url'] = "http://apache.mirrors.pair.com/tomcat/tomcat-#{node['spiral']['tomcat']['series']}/v#{node['spiral']['tomcat']['version']}/bin/apache-tomcat-#{node['spiral']['tomcat']['version']}.tar.gz"

default['spiral']['tomcat']['java_opts'] = '-Xmx2048m -Xms512m -XX:MaxPermSize=512m'
