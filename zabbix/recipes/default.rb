package 'python-pip'

execute 'install_zabbix_repo_key' do
  command 'curl http://repo.zabbix.com/zabbix-official-repo.key | apt-key add -'
  not_if 'apt-key list | grep "Zabbix SIA"'
end

apt_repository 'zabbix' do
  uri 'http://repo.zabbix.com/zabbix/2.4/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  action :add
end
