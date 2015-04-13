default['spiral']['tomcat']['series'] = '7' 
default['spiral']['tomcat']['version'] = '7.0.61'

default['spiral']['tomcat']['url'] = "http://apache.mirrors.pair.com/tomcat/tomcat-#{node['spiral']['tomcat']['series']}/v#{node['spiral']['tomcat']['version']}/bin/apache-tomcat-#{node['spiral']['tomcat']['version']}.tar.gz"
