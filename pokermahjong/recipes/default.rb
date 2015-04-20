cookbook_file '/home/ubuntu/.ssh/id_rsa' do
  source 'swcore-git.key'
  owner  'ubuntu'
  group  'ubuntu'
  mode   '0600'
  action :create
end
