include_recipe 'nfs::client4'
include_recipe 'spiral::users'
include_recipe 'spiral::newrelic'

package 'git'
package 'nfs-common'

execute 'git_url_default_to_https' do
  command 'git config --global url."https://".insteadOf git://'
  user 'deploy'
  environment ({ 'HOME' => '/home/deploy' })
end

if node['spiral']['graylog']['enable'] == true
  service 'rsyslog' do
    action :enable
    supports :status => true, :start => true, :stop => true, :restart => true
  end

  template '/etc/rsyslog.d/99-graylog.conf' do
    source 'rsyslog-graylog.conf.erb'
    owner  'root'
    group  'root'
    mode   '0644'
    action :create
    notifies :restart, 'service[rsyslog]'
  end
end
