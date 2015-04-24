include_recipe "nginx"
include_recipe "hhvm"

package 'memcached' do
        action :install
end

directory "/opt/cms" do
        owner 'www-data'
        group 'www-data'
        mode '0644'
        action :create
end

template '/opt/cms/test.php' do
	source 'test.php.erb'
	mode '644'
	owner 'www-data'
	group 'www-data'
end

execute "create_symlink_cmsdir" do
	command 'ln -s /var/www/html/cms /opt/cms'
	not_if { ::File.directory?("/var/www/html/cms")}
end

template '/etc/nginx/sites-available/cms'
	source 'cms.erb'
	mode '644'
	owner 'www-data'
	group 'www-data'
end

execute "create_symlink_cmssite" do
        command 'ln -s /etc/nginx/sites-enabled/cms /etc/nginx/sites-availbale/cms'
	not_if { ::File.exists?("/etc/nginx/sites-enabled/cms")}
end

service 'nginx'
	action :restart
end
