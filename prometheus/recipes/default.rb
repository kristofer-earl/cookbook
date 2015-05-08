include_recipe 'spiral::phpfpm'

user 'deploy' do
  supports :manage_home => true
  comment 'Capistrano Deployment'
  uid 2222 
  gid 'www-data'
  home '/home/deploy'
  shell '/bin/bash'
end

directory '/home/deploy/.ssh' do
  owner 'root'
  group 'root'
  mode '0700'
  action :create
end
