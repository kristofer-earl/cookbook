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