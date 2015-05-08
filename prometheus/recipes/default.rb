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

# hack sudoers

bash "insert_sudo_for_deploy" do
  user "root"
  code <<-EOS
  echo "deploy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  EOS
  not_if "grep -q 'deploy ALL=(ALL) NOPASSWD:ALL' /etc/sudoers"
end
