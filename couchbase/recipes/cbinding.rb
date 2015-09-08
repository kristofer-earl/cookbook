execute 'add_couchbase_repo_key' do
  command 'wget -O - -q http://packages.couchbase.com/rpm/couchbase-rpm.key | apt-key add -'
  not_if 'apt-key list | grep "Couchbase Release Key <support@couchbase.com>"'
end

cookbook_file '/etc/apt/sources.list.d/couchbase.list' do
  source 'couchbase.list'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :run, 'execute[apt-get update]', :immediately
end

package 'libcouchbase-dev'
