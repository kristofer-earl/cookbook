package 'nginx-full'

cookbook_file 'default' do
  path   '/etc/nginx/sites-enabled/default'
  notifies :restart, "service[nginx]"
  action :delete
end
