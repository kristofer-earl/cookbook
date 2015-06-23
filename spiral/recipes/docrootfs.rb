include_recipe 'spiral::default'
include_recipe 'nfs::server'

nfs_export '/srv' do
  # this is generally a VERY VERY bad idea but in this case
  # either AWS security groups or Firewalling must handle this!
  network '0.0.0.0/0'
  writeable true 
  sync false 
  options ['no_root_squash', 'no_subtree_check']
end
