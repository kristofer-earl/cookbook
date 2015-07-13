case node['platform_family']
when 'debian'
  include_recipe 'apt'

  package 'apt-transport-https'

  #apt_repository 'node.js' do
  #  uri node['nodejs']['repo']
  #  distribution node['lsb']['codename']
  #  components ['main']
  #  keyserver node['nodejs']['keyserver']
  #  key node['nodejs']['key']
  #end

  execute 'node.js_ppa' do
    command '/usr/bin/apt-add-repository -y ppa:chris-lea/node.js'
  end
  
when 'rhel'
  include_recipe 'yum-epel'
end
