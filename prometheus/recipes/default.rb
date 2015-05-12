include_recipe 'spiral::phpfpm'

directory '/home/deploy/.ssh' do
  owner 'deploy'
  group 'www-data'
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
