#
# Cookbook Name:: prometheus-cms
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"
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
