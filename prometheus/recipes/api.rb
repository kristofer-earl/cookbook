#
# Cookbook Name:: prometheus
# Recipe:: api
#
# Copyright 2015, SpiralWorks
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx"
include_recipe "hhvm"
include_recipe "composer"
include_recipe "php5-fpm::install"


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

execute 'laravel-install' do
	command 'composer global require "laravel/installer=~1.1"'
end

template '/etc/nginx/sites-available/api' do
	source 'api.erb'
	mode '755'
	owner 'www-data'
	group 'www-data'
end

link '/etc/nginx/sites-enabled/api' do
	to '/etc/nginx/sites-available/api'
	link_type :symbolic
	action :create
end