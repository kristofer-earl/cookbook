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

template "#{phabricator_dir}/bin/firstadmin.php" do
    source "firstadmin.erb"
    mode 0777
    action :create
end

template "#{phabricator_dir}/initialdata.sql" do
    source "initialdata.erb"
    action :create
    mode 0777
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

directory "#{phabricator_dir}/tags/"

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

bash "Add first Admin" do
   cwd phabricator_dir
   code "./bin/firstadmin.php"
   action :run
   notifies :create, 'file[tag1]', :immediately
   not_if do ::File.exists?("#{phabricator_dir}/tags/firstuser.tag") end
end

tag1 = "#{phabricator_dir}/tags/firstuser.tag"

file tag1 do
   action :nothing
end

execute "enable password auth" do
   command "mysql -u root pabricator_auth < #{phabricator_dir}/initialdata.sql"
   notifies :create, 'file[tag2]', :immediately
   not_if do ::File.exists?("#{phabricator_dir}/tags/authpass.tag") end
end

tag2 = "#{phabricator_dir}/tags/authpass.tag"

file tag2 do
   action :nothing
end

file "#{phabricator_dir}/bin/firstadmin.php" do
   action :delete
end

file "#{phabricator_dir}/initialdata.sql" do
   action :delete
end

bash "Start Phabricator Daemon" do
    user install_user
    cwd phabricator_dir
    code "./bin/phd start"
    action :run
end
