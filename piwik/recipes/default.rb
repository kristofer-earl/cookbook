#
# Cookbook Name:: piwik
# Recipe:: default
#
# Copyright 2011, gutefrage.net GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "percona::client"
include_recipe "spiral::phpfpm"

template "/etc/nginx/sites-available/piwik" do
  source "nginx-site-piwik.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables(
      :piwik_install_path => node[:piwik][:install_path]
  )
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/piwik' do
  to '/etc/nginx/sites-available/piwik'
  notifies :restart, "service[nginx]"
end

include_recipe "logrotate"
logrotate_app 'nginx' do
  paths      "/var/log/nginx/*.log"
  rotate     35
  period     "daily"
  postrotate "test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`"
end

include_recipe "iptables"
iptables_rule "iptables_http"

piwik_version = node[:piwik][:version]

remote_file "#{Chef::Config[:file_cache_path]}/piwik-#{piwik_version}.tar.gz" do
  source "http://builds.piwik.org/piwik-#{piwik_version}.tar.gz"
  action :create_if_missing
end

directory node[:piwik][:install_path] do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

bash "install_piwik" do
  cwd Chef::Config[:file_cache_path]
  user 'root'
  code <<-EOH
    tar zxf piwik-#{piwik_version}.tar.gz
    mv piwik #{node[:piwik][:install_path]}
    echo '#{piwik_version}' > #{node[:piwik][:install_path]}/piwik/VERSION
  EOH
  not_if "test `cat #{node[:piwik][:install_path]}/piwik/VERSION` = #{piwik_version}"
end
