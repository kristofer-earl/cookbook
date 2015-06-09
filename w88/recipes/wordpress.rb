include_recipe 'percona::client'
include_recipe 'spiral::phpfpm'

directory '/srv/http' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end

directory '/srv/http/wordpress' do
  owner 'www-data'
  group 'www-data'
  mode  '0774'
  action :create
end
