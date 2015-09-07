include_recipe 'spiral::nginx'

template '/etc/nginx/sites-available/bogw.conf' do
  source   'bogw.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  action   :create
  notifies :restart, "service[nginx]"
end

link '/etc/nginx/sites-enabled/bogw.conf' do
  to '/etc/nginx/sites-available/bogw.conf'
  notifies :restart, "service[nginx]"
end
