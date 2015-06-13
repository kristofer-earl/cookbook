include_recipe 'socialcasino::default'

cookbook_file 'deploy.pub' do
  path  '/home/deploy/.ssh/authorized_keys.api'
  owner 'deploy'
  group 'www-data'
  mode  '0600'
  action :create
end

bash "insert_line" do
  user "deploy"
  code <<-EOS
    cat /home/deploy/.ssh/authorized_keys.api >> /home/deploy/.ssh/authorized_keys
  EOS
  not_if "grep -q 'socialcasino.key' /home/deploy/.ssh/authorized_keys"
end

template '/etc/nginx/sites-available/socialcasino.conf' do
  source   'nginx.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

directory '/srv/http/socialcasino' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/socialcasino/shared' do
  owner 'deploy'
  group 'www-data'
  mode  '0774'
  action :create
end

link '/etc/nginx/sites-enabled/socialcasino.conf' do
  to '/etc/nginx/sites-available/socialcasino.conf'
  notifies :restart, "service[nginx]"
end
