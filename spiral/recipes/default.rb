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
