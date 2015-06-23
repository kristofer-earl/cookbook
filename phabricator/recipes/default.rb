#
## Cookbook Name:: phabricator
## Recipe:: default
##
## Copyright 2015
##
#

#package 'nginx'
#package 'php5-fpm'
#package 'mysql-server-core-5.5'
#package 'mysql-server-5.5'
#package 'mysql-client-5.5'
#package 'php5-cli'
#package 'php5-mysql'
#package 'php5-curl'

# Install required packages
Rpackages = ["nginx",
             "php5-fpm",
             "mysql-server-core-5.5",
             "mysql-server-5.5",
             "mysql-client-5.5",
             "php5-cli",
             "php5-mysql",
             "php5-curl"]

Rpackages.each do |pkg|
    package pkg
end

# user to own the checked out files
install_user = node['phabricator']['user']
# dir where phabricator and deps are installed
install_dir = node['phabricator']['install_dir']
# phabricator dir, used too often, so create local variable
phabricator_dir = "#{install_dir}/phabricator"

# checkout code
packages = %w{phabricator libphutil arcanist}
packages.each do |pkg|
    git "#{install_dir}/#{pkg}" do
        user install_user
        repository "git://github.com/facebook/#{pkg}.git"
        reference "master"
        action :checkout
    end
end

template "Configure Phabricator" do
    path "#{phabricator_dir}/conf/local/local.json"
    source "local.json.erb"
    user install_user
    mode 0644
    variables ({ :config => node['phabricator']['config'] })
    notifies :run, "bash[Upgrade Phabricator storage]", :immediately
end

bash "Upgrade Phabricator storage" do
    user install_user
    cwd phabricator_dir
    code "./bin/storage upgrade --force"
    action :nothing
    notifies :create, "template[Create admin script]", :immediately
end

# Install custom script to easily install an admin user
template "Create admin script" do
    path "#{phabricator_dir}/scripts/user/admin.php"
    source "account.erb"
    user install_user
    mode 0755
    action :nothing
    notifies :run, "bash[Install admin account]", :immediately
end

bash "Install admin account" do
    user install_user
    cwd "#{phabricator_dir}/scripts/user"
    code "./admin.php"
    action :nothing
    notifies :delete, "file[Remove admin script]", :immediately
end

file "Remove admin script" do
    path "#{phabricator_dir}/scripts/user/admin.php"
    action :nothing
end

# just to be sure dirs exist
directory "/etc/nginx/sites-available"
directory "/etc/nginx/sites-enabled"

# enable and start, will reload if symlink is created or config updated
service "nginx" do
    service_name node['phabricator']['nginx']['service']
    action [:enable, :start]
end

# Set nginx dependencies.
template "/etc/nginx/sites-available/phabricator" do
    source "nginx.erb"
    variables ({ :phabricator_dir => phabricator_dir })
    mode 0644
    notifies :reload, "service[nginx]"
end

link "Enable Phabricator for nginx" do
    to "../sites-available/phabricator"
    target_file "/etc/nginx/sites-enabled/phabricator"
    notifies :reload, "service[nginx]"
end
