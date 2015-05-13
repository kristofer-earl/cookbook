apt_repository 'nginx' do
  uri 'http://ppa.launchpad.net/nginx/stable/ubuntu'
  distribution node['lsb']['codename'] 
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'C300EE8C'
  action :add
end 

package 'nginx-full'

cookbook_file 'default' do
  path   '/etc/nginx/sites-enabled/default'
  notifies :restart, "service[nginx]"
  action :delete
  manage_symlink_source true
end

service 'nginx' do
  action :enable
  supports :status => true, :start => true, :stop => true, :restart => true
end
