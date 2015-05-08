include_recipe 'prometheus::default'

cookbook_file 'api-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end
