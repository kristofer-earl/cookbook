include_recipe 'spiral::default'

execute 'add_nginx_ppa' do
  command '/usr/bin/apt-add-repository -y ppa:nginx/stable; /usr/bin/apt-get update'
end

package 'nginx-full'
package 'nginx-extras'

cookbook_file 'nginx-server.conf' do
  path   '/etc/nginx/nginx.conf'
  notifies :restart, 'service[nginx]'
  action :delete
  manage_symlink_source true
end

cookbook_file 'default' do
  path   '/etc/nginx/sites-enabled/default'
  notifies :restart, 'service[nginx]'
  action :delete
  manage_symlink_source true
end

directory '/var/log/nginx' do
  owner  'www-data'
  group  'www-data'
  mode   '0755'
  action :create
end

service 'nginx' do
  action :enable
  supports :status => true, :start => true, :stop => true, :restart => true
end
