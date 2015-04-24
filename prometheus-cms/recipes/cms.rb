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

execute "create_symlink" do
	command 'ln -s /var/www/html/cms /opt/cms'
end
