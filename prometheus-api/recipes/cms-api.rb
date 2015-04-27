#
# Cookbook Name:: prometheus-api
# Recipe:: cms-api
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "php"
include_recipe "nginx"
include_recipe "hhvm"
include_recipe "composer"
include_recipe "php5-fpm"


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

execute 'laravel-install'
	command 'composer global require "laravel/installer=~1.1"'
end
