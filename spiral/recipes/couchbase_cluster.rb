include_recipe 'spiral::default'
include_recipe 'couchbase'

couchbase_cluster node[:spiral][:couchbase][:name] do
  memory_quota_mb 512 

  username node[:spiral][:couchbase][:username] 
  password node[:spiral][:couchbase][:password] 
end
