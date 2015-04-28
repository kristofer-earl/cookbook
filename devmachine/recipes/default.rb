#
# Cookbook Name:: devmachine
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx"
include_recipe "hhvm"
include_recipe "composer"
include_recipe "php5-fpm:install"

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
