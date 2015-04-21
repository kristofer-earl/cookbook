cookbook_file '/root/.ssh/id_rsa' do
  source 'swcore-git.key'
  owner  'root'
  group  'root'
  mode   '0600'
  action :create
end
