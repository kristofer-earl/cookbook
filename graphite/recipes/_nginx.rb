#
# Cookbook Name:: graphite
# Recipe:: _nginx
#
# Copyright (C) 2014, Chef Software, Inc <legal@getchef.com>

package 'nginx'

node.default['graphite']['uwsgi']['listen_ip'] = '127.0.0.1'
node.default['graphite']['uwsgi']['listen_port'] = '8081'
include_recipe 'graphite::_uwsgi'

template '/etc/nginx/sites-available/graphite' do
  source 'nginx-graphite.erb'
  owner 'root'
  group 'root'
  mode 0644

  notifies :reload, 'service[nginx]', :delayed
end

link '/etc/nginx/sites-enabled/graphite' do
  to '/etc/nginx/sites-available/graphite'
end

file '/etc/nginx/sites-enabled/default' do
  action :delete

  notifies :reload, 'service[nginx]', :delayed
  only_if { node['graphite']['nginx']['disable_default_vhost'] }
end

service 'nginx' do
  action [:enable, :start]
  supports :restart => true, :reload => true
end
