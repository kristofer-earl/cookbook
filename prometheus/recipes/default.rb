include_recipe 'percona::client'

cookbook_file 'nginx-cors.conf' do
  path  '/etc/nginx/cors.conf'
  owner 'root'
  group 'root'
  mode  '0644'
  action :create
end

directory '/home/deploy/.ssh' do
  owner 'deploy'
  group 'www-data'
  mode '0700'
  action :create
end

cookbook_file '/etc/profile.d/spiral-deploy.sh' do
  owner  'root'
  group  'root'
  mode   '0755'
  source 'spiral-deploy.sh'
  action :create
end

cookbook_file '/etc/login.defs' do
  owner 'root'
  group 'root'
  mode  '0644'
  source 'login.defs'
  action :create
end

# hack sudoers
bash "insert_sudo_for_deploy" do
  user "root"
  code <<-EOS
  echo "deploy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  EOS
  not_if "grep -q 'deploy ALL=(ALL) NOPASSWD:ALL' /etc/sudoers"
end

package 'nodejs'
package 'nodejs-dev'
package 'npm'

link '/usr/bin/node' do
  to '/usr/bin/nodejs'
end

execute 'install_bundler' do
  command 'gem install bundler'
  creates '/usr/local/bin/bundler'
end

execute 'install_sass' do
  command 'gem install sass'
  creates '/usr/local/bin/sass'
end

execute 'install_bower' do
  command 'npm install -g bower'
  creates '/usr/loca/bin/bower'
end
