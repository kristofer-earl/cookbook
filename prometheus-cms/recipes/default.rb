#
# Cookbook Name:: prometheus-cms
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#include_recipe "php::module_mysql"
#include_recipe "apache2::mod_php5"
include_recipe "nginx"
include_recipe "hhvm"
#include_recipe "composer"
#include_recipe "php5-fpm"


package 'memcached' do
        action :install
end
