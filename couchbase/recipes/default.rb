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
