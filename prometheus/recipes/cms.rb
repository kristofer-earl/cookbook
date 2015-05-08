include_recipe 'prometheus::default'

cookbook_file 'cms-deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end

template '/etc/cms_settings.php' do
        source 'settings.php.erb'
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
  mode     '0755'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/cms-nginx.conf' do
  to '/etc/nginx/sites-available/cms-nginx.conf'
  notifies :restart, "service[nginx]"
end
