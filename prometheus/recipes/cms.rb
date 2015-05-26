include_recipe 'memcached'
include_recipe 'prometheus::default'

cookbook_file 'cms-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys.cms'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end

bash "insert_line" do
  user "deploy"
  code <<-EOS
    cat /home/deploy/.ssh/authorized_keys.cms >> /home/deploy/.ssh/authorized_keys
  EOS
  not_if "grep -q 'prometheus-cms.key' /home/deploy/.ssh/authorized_keys"
end

directory '/srv/http/cms' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/cms/shared' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/cms/shared/sites' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/cms/shared/sites/default' do
  owner 'deploy'
  group 'www-data'
  mode '0755'
  action :create
end

template '/srv/http/cms/shared/sites/default/settings.php' do
        source 'cms_settings.php.erb'
        mode '644'
        owner 'www-data'
        group 'www-data'
        variables ({ :database => node['prometheus']['cms_db_name'],
                     :username => node['prometheus']['cms_db_user'],
                     :password => node['prometheus']['cms_db_pass'],
                     :host => node['prometheus']['cms_db_host'],
                     :port => node['prometheus']['cms_db_port'],
                     :driver => node['prometheus']['cms_db_driver'],
                     :prefix => node['prometheus']['cms_db_prefix'] })
end

directory '/var/log/nginx/cms' do
        owner 'www-data'
        group 'www-data'
        mode '0755'
        action :create
end

template '/etc/nginx/sites-available/cms-nginx.conf' do
  source   'cms-nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/cms-nginx.conf' do
  to '/etc/nginx/sites-available/cms-nginx.conf'
  notifies :restart, "service[nginx]"
end

directory '/srv/http/cms/shared' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

execute 'install_drush7' do
  command 'composer global require drush/drush:7.*'
end
