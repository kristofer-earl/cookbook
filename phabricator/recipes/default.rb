## Cookbook Name:: phabricator
## Recipe:: default
##
## Copyright 2015
##


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

install_user = node['phabricator']['user']
domain_name = node['phabricator']['domain']
install_dir = node['phabricator']['install_dir']
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

bash "Upgrade Phabricator storage" do
    user install_user
    cwd phabricator_dir
    code "./bin/storage upgrade --force"
    action :run
end

bash "Set Base URI" do
    user install_user
    cwd phabricator_dir
    code "./bin/config set phabricator.base-uri http://#{domain_name}/"
    action :run
end

template "/etc/php5/fpm/pool.d/www.conf" do
    source "fpm.erb"
    mode 0755
    action :create
end

execute "restart_php5-fpm" do
    command 'sudo service php5-fpm restart'
end

# just to be sure dirs exist
directory "/etc/nginx/sites-available"
directory "/etc/nginx/sites-enabled"

# enable and start, will reload if symlink is created or config updated
service "nginx" do
    action [:enable, :start]
end

# Set nginx dependencies.
template "/etc/nginx/sites-available/phabricator" do
    source "nginx.erb"
    variables ({ :phabricator_dir => phabricator_dir })
    mode 0644
    notifies :reload, "service[nginx]"
end

file "/etc/nginx/sites-enabled/default" do
    action :delete
    force_unlink true
end

link "Enable Phabricator for nginx" do
    to "../sites-available/phabricator"
    target_file "/etc/nginx/sites-enabled/phabricator"
end

execute "restart-nginx" do
    command "sudo service nginx restart"
end

bash "Start Phabricator Daemon" do
    user install_user
    cwd phabricator_dir
    code "./bin/phd start"
    action :run
end
