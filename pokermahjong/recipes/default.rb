include_recipe 'spiral::default'

package 'ant'
package 'maven'

directory node['pokermahjong']['src_path'] do
  owner 'root'
  group node['spiral']['users']['group']
  mode '0755'
  action :create
end

template "/etc/serverinfo.properties" do
  source 'serverinfo.properties.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  action :create
end
