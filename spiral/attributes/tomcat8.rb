default['spiral']['tomcat8']['series'] = '8' 
default['spiral']['tomcat8']['version'] = '8.0.21'

default['spiral']['tomcat8']['url'] = "http://apache.mirrors.pair.com/tomcat/tomcat-#{node['spiral']['tomcat']['series']}/v#{node['spiral']['tomcat']['version']}/bin/apache-tomcat-#{node['spiral']['tomcat']['version']}.tar.gz"

default['spiral']['tomcat8']['java_opts'] = '-Xmx1024m -Xms512m -XX:MaxPermSize=256m'
