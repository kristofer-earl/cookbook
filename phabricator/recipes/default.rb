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
             "php5-curl",
             "php5-gd",
	     "php5-apcu",
             "sendmail",
             "python-pygments"]

Rpackages.each do |pkg|
    package pkg
end

install_user = node['phabricator']['user']
domain_name = node['phabricator']['domain']
cdn = node['phabricator']['alternate-domain']
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

execute "enable password auth" do
   command "mysql -u root phabricator_auth < #{phabricator_dir}/initialdata.sql"
   notifies :create, 'file[/usr/tags/authpass.tag]', :immediately
   not_if do ::File.exists?('/usr/tags/authpass.tag') end
end

file "/usr/tags/authpass.tag" do
   action :nothing
end

template "/etc/mysql/my.cnf" do
    source "my.cnf.erb"
    mode 0755
    action :create
end

service 'mysql' do
   action :stop
end

service 'mysql' do
   action :start
end

bash "Set CDN" do
    user install_user
    cwd phabricator_dir
    code "./bin/config set security.alternate-file-domain http://#{cdn}/"
    action :run
end

bash "Enable Pygments" do
    user install_user
    cwd phabricator_dir
    code "./bin/config set pygments.enabled true"
    action :run
end

bash "Set Base URI" do
    user install_user
    cwd phabricator_dir
    code "./bin/config set phabricator.base-uri http://#{domain_name}/"
    action :run
end

template "/etc/php5/fpm/php.ini" do
    source "php.ini.erb"
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

directory "/usr/tags"
directory "/var/repo" do
    mode 0777
end

directory "/var/storage_engine" do
    mode 0777
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

bash "Add first Admin" do
   cwd phabricator_dir
   code "./bin/firstadmin.php"
   action :run
   notifies :create, 'file[/usr/tags/firstuser.tag]', :immediately
   not_if do ::File.exists?('usr/tags/firstuser.tag') end
end

file "/usr/tags/firstuser.tag" do
   action :nothing
end

file "#{phabricator_dir}/bin/firstadmin.php" do
   action :delete
end

file "#{phabricator_dir}/initialdata.sql" do
   action :delete
end

bash "Set Storage Engine" do
    user install_user
    cwd phabricator_dir
    code "./bin/config set storage.local-disk.path '/var/test/'"
    action :run
end

bash "Start Phabricator Daemon" do
    user install_user
    cwd phabricator_dir
    code "./bin/phd start"
    action :run
    not_if (!('./bin/phd status | grep "There are no running Phabricator daemons."')), :cwd => phabricator_dir, :user => install_user
end
