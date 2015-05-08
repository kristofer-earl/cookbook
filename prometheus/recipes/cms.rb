include_recipe 'prometheus::default'

cookbook_file 'cms-deploy.pub' do
  path  '/home/depoy/.ssh/authorized_keys'
  owner 'deploy'
  group 'deploy'
  mode  '0600'
  action :delete
end
