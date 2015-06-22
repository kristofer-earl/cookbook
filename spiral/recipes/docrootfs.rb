include_recipe 'spiral::default'
include_recipe 'nfs::server'

nfs_export '/srv' do
  network '0.0.0.0/0'
  writeable true 
  sync false 
  options ['no_root_squash', 'no_subtree_check']
end
