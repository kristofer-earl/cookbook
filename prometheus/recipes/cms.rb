#
# Cookbook Name:: prometheus
# Recipe:: cms
#
# Copyright 2015, SpiralWorks
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx"
include_recipe "hhvm"
include_recipe "php5-fpm::install"

package 'memcached' do
        action :install
end

directory '/var/www' do
        owner 'www-data'
        group 'www-data'
        mode '0755'
        action :create
end

directory '/var/www/cms' do
        owner 'www-data'
        group 'www-data'
        mode '0755'
        action :create
end

directory '/tmp/cms' do
        mode '0755'
        action :create
end

template '/tmp/cms/settings.php' do
        source 'settings.php.erb'
        mode '644'
        owner 'www-data'
        group 'www-data'
        variables ({ :database => node['prometheus']['cms_db_name'],
                :username => node['prometheus']['cms_db_user'],
                :password => node['prometheus']['cms_db_pass'],
                :host => node['prometheus']['cms_db_host'],
                :port => node['prometheus']['cms_db_port'],
                :driver => node['prometheus']['cms_db_driver'],
                :prefix => node['prometheus']['cms_db_prefix'] })
end

directory '/var/log/nginx/cms' do
        owner 'www-data'
        group 'www-data'
        mode '0755'
        action :create
end

template '/var/www/cms/test.php' do
        source 'test.php.erb'
        mode '755'
        owner 'www-data'
        group 'www-data'
end

template '/etc/nginx/sites-available/cms' do
        source 'cms.erb'
        mode '755'
        owner 'www-data'
        group 'www-data'
end

link '/etc/nginx/sites-enabled/cms' do
        to '/etc/nginx/sites-available/cms'
        link_type :symbolic
        action :create
end

link '/etc/nginx/sites-enabled/default' do
        action :delete
end

service 'nginx' do
        action :restart
end