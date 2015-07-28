default['spiral']['tomcat']['series'] = '7' 
default['spiral']['tomcat']['version'] = '7.0.63'

default['spiral']['tomcat']['url'] = "http://apache.mirrors.pair.com/tomcat/tomcat-#{node['spiral']['tomcat']['series']}/v#{node['spiral']['tomcat']['version']}/bin/apache-tomcat-#{node['spiral']['tomcat']['version']}.tar.gz"

default['spiral']['tomcat']['java_opts'] = '-javaagent:/opt/newrelic/newrelic.jar -Xmx2048m -Xms512m -XX:MaxPermSize=512m -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=10999 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false '
