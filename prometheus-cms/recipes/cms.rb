include_recipe "nginx"
include_recipe "hhvm"

package 'memcached' do
        action :install
end

template '/opt/cms/test.php' do
	source 'test.php.erb'
	mode '644'
	owner 'www-data'
	group 'www-data'
end

#link '/opt/cms/' do
#  to '/var/www/html/cms/'
#  action :create
#end

execute "create_symlink" do
	command 'ln -s /var/www/html/cms /opt/cms'
end

