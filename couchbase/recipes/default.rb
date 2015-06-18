#
# Cookbook Name:: couchbase
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'libssl1.0.0'

remote_file '/tmp/couchbase-server-community_3.0.1-ubuntu12.04_amd64.deb' do
   source 'http://packages.couchbase.com/releases/3.0.1/couchbase-server-community_3.0.1-ubuntu12.04_amd64.deb'
   action :create_if_missing
end

dpkg_package '/tmp/couchbase-server-community_3.0.1-ubuntu12.04_amd64.deb' do
   action :install
end

service "couchbase-server" do
  supports :restart => true, :status => true
  action [:enable, :start]
end

http_request "initialize_cluster" do
  url "http://127.0.0.1:8091/nodes/self/controller/settings"
  action :post
end

execute "admin credentials" do
  command "curl -d username=Administrator -d password=spiralworks -d port=8091 http://127.0.0.1:8091/settings/web"
end

#http_request "posting data" do
#  action :post
#  url "http://127.0.0.1:8091/settings/web"
#  message ({:username => "Administrator", :password => "spiralworks", :port => "8091"}.to_json)
#  headers({"AUTHORIZATION" => "Basic #{Base64.encode64("username:password")}","Content-Type" => "application/data"})
#end
