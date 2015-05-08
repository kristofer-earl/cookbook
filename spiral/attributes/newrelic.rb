default['newrelic']['license_key'] = 'NONE'
default['newrelic']['app_name_prefix'] = 'NONE'

if defined? node['opsworks']['instance']['layers'].first
  default['pokermahjong']['nr_app_name'] = "#{node[:newrelic][:app_name_prefix]}_#{node[:opsworks][:instance][:hostname]}"
else
  default['pokermahjong']['nr_app_name'] = "#{node[:newrelic][:app_name_prefix]}_#{node['fqdn']}"
end
