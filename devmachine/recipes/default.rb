#
# Cookbook Name:: devmachine
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "git"
include_recipe "apache2"
#include_recipe "mysql::client"
#include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"
include_recipe "nginx"
include_recipe "hhvm"
include_recipe "composer"
include_recipe "php5-fpm"

apache_site "default" do
  enable false
end

package 'memcached' do
	action :install
end

package 'php5-memcached' do
	action :install
end

package 'php5-mcrypt' do
	action :install
end

execute 'applymcrypt' do
	command 'php5enmod mcrypt'
end

execute 'install_laravel' do
	command 'composer global require "laravel/installer=~1.1"'
end

package 'expect' do
	action :install
end

execute 'remove_cms-api_directory' do
	command 'rm -rf /home/ubuntu/cms-api/'
	only_if { Dir.exist?("/home/ubuntu/cms-api") }
end

#remaining steps can be replaced with app deploy or teamcity for an updated content.
#git '~/cms-api' do
#	repository 'git@github.com:MainSystemDev/PrometheusApi.git'
#	revision 'master'	
#	action :sync
#end

#bash 'cms-api-git' do
#	code 'source /home/ubuntu/chef-repo/run_me.sh'
#end

