include_recipe 'rabbitmq::mgmt_console '

rabbitmq_user 'guest' do
  action :delete
end

rabbitmq_user 'scas' do
  password 'scas'
  vhost '/'
  permissions '.* .* .*'
  action :add
end
