package 'vsftpd'

directory '/srv/ftp' do
  owner 'ftp'
  group 'www-data'
  mode  '0755'
  action :create
end
