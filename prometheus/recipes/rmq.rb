include_recipe 'rabbitmq::mgmt_console'

rabbitmq_user 'guest' do
  action :delete
end

rabbitmq_user 'prom' do
  password 'prom'
  vhost '/'
  permissions '.* .* .*'
  action :add
end
