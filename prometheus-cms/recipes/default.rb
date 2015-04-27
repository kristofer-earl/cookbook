#
# Cookbook Name:: prometheus-cms
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe "nginx"
include_recipe "hhvm"


package 'memcached' do
        action :install
end

directory "/opt/cms" do
	owner 'www-data'
	group 'www-data'
	mode '0755'
	action :create
end
