
package 'libssl1.0.0'

remote_file "/tmp/#{node['couchbase']['package']}" do
   source "#{node['couchbase']['url']}/#{node['couchbase']['package']}"
   #source 'http://packages.couchbase.com/releases/3.0.1/couchbase-server-community_3.0.1-ubuntu12.04_amd64.deb'
   action :create_if_missing
end

dpkg_package "/tmp/#{node['couchbase']['package']}" do
   action :install
end

service "couchbase-server" do
  supports :restart => true, :status => true
  action [:enable, :start]
end

http_request "initialize_cluster" do
  url "http://127.0.0.1:8091/nodes/self/controller/settings"
  headers({"AUTHORIZATION" => "Basic #{Base64.encode64("Administrator:#{node['couchbase']['password']}")}","Content-Type" => "application/data"})
  action :post
end

#execute "initialize cluster" do
#  command "curl -X POST -u Administrator:#{node['couchbase']['password']} http://127.0.0.1:8091/nodes/self/controller/settings"
#end

execute "set memoryQuota" do
  command "curl -X POST -u Administrator:#{node['couchbase']['password']} -d memoryQuota=#{node['couchbase']['memoryQuota']}  http://127.0.0.1:8091/pools/default"
end

execute "admin credentials" do
  command "curl -X POST -u Administrator:#{node['couchbase']['password']} -d username=Administrator -d password=#{node['couchbase']['password']} -d port=8091 http://127.0.0.1:8091/settings/web"
end
