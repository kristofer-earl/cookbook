package 'ant'
package 'maven'

cookbook_file '/root/.ssh/id_rsa' do
  source 'swcore-git.key'
  owner  'root'
  group  'root'
  mode   '0600'
  action :create
end

directory node['pokermahjong']['src_path'] do
  owner 'root'
  group node['spiral']['users']['group']
  mode '0755'
  action :create
end
