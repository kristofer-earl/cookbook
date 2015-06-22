include_recipe 'apt'
include_recipe 'nfs::client4'
include_recipe 'spiral::users'
include_recipe 'spiral::newrelic'

execute 'custom_apt_list_update' do
  command 'apt-get update'
end

apt_repository 'webupd8team-java-trusty' do
  uri 'http://ppa.launchpad.net/webupd8team/java/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'EEA14886'
end

execute 'accept_oracle_license' do
  command 'echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections'
end

package 'oracle-java7-installer'
package 'oracle-java7-unlimited-jce-policy'
package 'oracle-java7-set-default'
package 'git'
package 'nfs-common'

execute 'git_url_default_to_https' do
  command 'git config --global url."https://".insteadOf git://'
  user 'deploy'
  environment ({ 'HOME' => '/home/deploy' })
end

# get RDS instance for MySQL connection
#rds_instance_ip = Resolv.getaddress(node[:opsworks][:stack][:rds_instances].first[:address])
#rds_name = 'rds1.localdomain'

#bash "insert_line" do
#  user "root"
#  code <<-EOS
#  echo "#{rds_instance_ip} #{rds_name}" >> /etc/hosts
#  EOS
#  not_if "grep -q #{rds_name} /etc/hosts"
#end
