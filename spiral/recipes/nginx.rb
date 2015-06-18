include_recipe 'spiral::default'

execute "add_nginx_apt_key" do
  command "/usr/bin/apt-key add /usr/share/keyrings/nginx.gpg"
  notifies :run, resources(:execute => "custom_apt_list_update")
  action :nothing
end

cookbook_file  "/usr/share/keyrings/nginx.gpg" do
  mode "0644"
  owner "root"
  group "root"
  action :create
  backup false
  source  "nginx.gpg"
  notifies :run, resources(:execute => "add_nginx_apt_key")
end

apt_repository 'nginx' do
  uri 'http://ppa.launchpad.net/nginx/stable/ubuntu'
  distribution node['lsb']['codename'] 
  components ['main']
  action :add
end 

package 'nginx-full'
package 'nginx-extras'

cookbook_file 'default' do
  path   '/etc/nginx/sites-enabled/default'
  notifies :restart, "service[nginx]"
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
