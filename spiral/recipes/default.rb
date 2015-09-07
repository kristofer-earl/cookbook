include_recipe 'nfs::client4'
include_recipe 'spiral::users'
include_recipe 'spiral::newrelic'

package 'git'
package 'nfs-common'
package 'iptables-persistent'
package 'awscli'
package 'python-configobj'

remote_file '/usr/lib/apt/methods/s3' do
  source 'https://raw.githubusercontent.com/kth5/apt-transport-s3/master/s3'
  owner  'root'
  group  'root'
  mode   '755'
end

execute 'git_url_default_to_https' do
  command 'git config --global url."https://".insteadOf git://'
  user 'deploy'
  environment ({ 'HOME' => '/home/deploy' })
end

if node['spiral']['graylog']['enable'] == true
  service 'rsyslog' do
    action :enable
    supports :status => false, :start => true, :stop => true, :restart => true
    restart_command '/usr/sbin/invoke-rc.d rsyslog restart'
    start_command '/usr/sbin/invoke-rc.d rsyslog start'
    stop_command '/usr/sbin/invoke-rc.d rsyslog stop'
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
