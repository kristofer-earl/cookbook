if defined? node['opsworks']['instance']['layers'].first
  default['pokermahjong']['my_layer'] = node['opsworks']['instance']['layers'].first
end
