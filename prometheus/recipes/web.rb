include_recipe 'prometheus::default'

package 'nodejs'
package 'nodejs-dev'

cookbook_file 'web-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end
