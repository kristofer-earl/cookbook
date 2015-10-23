include_recipe 'spiral::default'
include_recipe 'nfs::server'

directory '/srv/http' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

nfs_export '/srv/http' do
  network '172.31.1.65'
  writeable true 
  sync false 
  options ['no_root_squash', 'no_subtree_check']
end
