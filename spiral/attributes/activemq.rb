default['spiral']['activemq']['version'] = '5.11.1'
default['spiral']['activemq']['url'] = "http://mirrors.ibiblio.org/apache/activemq/5.11.1/apache-activemq-#{node['spiral']['activemq']['version']}-bin.tar.gz"
default['spiral']['activemq']['java_opts'] = '-Xmx1024m -Xms512m -XX:MaxPermSize=256m'
default['spiral']['activemq']['max_connections'] = 1000
