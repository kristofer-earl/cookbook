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

template '/etc/nginx/sites-available/web-nginx.conf' do
  source   'web-nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0755'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/web-nginx.conf' do
  to '/etc/nginx/sites-available/web-nginx.conf'
  notifies :restart, "service[nginx]"
end

directory '/srv/http/web' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/web/shared' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end
