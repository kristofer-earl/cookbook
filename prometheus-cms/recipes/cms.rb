include_recipe "nginx"
include_recipe "hhvm"

package 'memcached' do
        action :install
end

directory '/opt/cms' do
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

#execute "create_symlink_cmsdir" do
#	command 'ln -s /opt/cms /var/www/html/cms'
#	not_if { ::File.directory?("/var/www/html/cms")}
#end

link '/var/www/html/cms' do
	to '/opt/cms'
	link_type :symbolic
	action :create
end

template '/etc/nginx/sites-available/cms' do
	source 'cms.erb'
	mode '644'
	owner 'www-data'
	group 'www-data'
end

#execute "create_symlink_cmssite" do
#        command 'ln -s /etc/nginx/sites-available/cms /etc/nginx/sites-enabled/cms'
#	not_if { ::File.exists?("/etc/nginx/sites-enabled/cms")}
#end

service 'nginx' do
	action :restart
end
