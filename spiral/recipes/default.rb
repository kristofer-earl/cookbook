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
