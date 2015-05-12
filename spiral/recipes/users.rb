group node['spiral']['users']['group'] do
  action :create
  append true
end

user 'tomcat' do
  comment 'Tomcat'
  system true
  gid node['spiral']['users']['group'] 
  shell '/bin/false'
  action :create
end

user 'activemq' do
  comment 'activemq'
  system true
  gid node['spiral']['users']['group'] 
  shell '/bin/false'
  action :create
end

user 'deploy' do
  supports :manage_home => true
  comment 'Capistrano Deployment'
  uid 2222
  gid 'www-data'
  home '/home/deploy'
  shell '/bin/bash'
end

cookbook_file '/etc/login.defs' do
  owner 'root'
  group 'root'
  mode  '0644'
  source 'login.defs'
  action :create
end
