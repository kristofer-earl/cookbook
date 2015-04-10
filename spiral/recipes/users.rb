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
