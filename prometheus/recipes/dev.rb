#
# Cookbook Name:: prometheus
# Recipe:: dev
#
# Copyright 2015, SpiralWorks
#
# All rights reserved - Do Not Redistribute
#
include_recipe "nginx"
include_recipe "hhvm"
include_recipe "composer"
include_recipe "php5-fpm:install"
include_recipe "php5"

package 'mysql-client-5.6' do
	action :install
	options '--force-yes'
end

package 'mysql-server-5.6' do
	action :install
        options '--force-yes'
end

package 'php5-mysql' do
	action :install
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
