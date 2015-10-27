include_recipe 'spiral::default'

# Install nfs
package 'nfs-kernel-server'

# Make directory
directory '/srv/http' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

# Configure nfs
nfs_export '/srv/http' do
  network '0.0.0.0/0'
  writeable true 
  sync false 
  options ['no_root_squash', 'no_subtree_check']
end

# Start/auto nfs 
service 'nfs-kernel-server' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
 

