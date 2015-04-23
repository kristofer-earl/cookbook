package 'ant'
package 'maven'

directory node['pokermahjong']['src_path'] do
  owner 'root'
  group node['spiral']['users']['group']
  mode '0755'
  action :create
end
