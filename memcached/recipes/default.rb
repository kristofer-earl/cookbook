package 'memcached' do
  action :upgrade
end

include_recipe 'memcached::service'

#
# be aware that Amazon Linux uses a different configuration schema.
case node[:platform]
when 'ubuntu','debian'
  template '/etc/memcached.conf' do
    source 'memcached.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      :user => node[:memcached][:user],
      :port => node[:memcached][:port],
      :memory => node[:memcached][:memory]
    )
    notifies :restart, "service[memcached]", :immediately
  end

  template '/etc/default/memcached' do
    source 'memcached.default.erb'
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, "service[memcached]", :immediately
  end

when 'centos','redhat','fedora','amazon'
  template '/etc/sysconfig/memcached' do
    source 'memcached.sysconfig.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      :user => node[:memcached][:user],
      :port => node[:memcached][:port],
      :memory => node[:memcached][:memory]
    )
    notifies :restart, "service[memcached]", :immediately
  end
end

if defined? node[:monit][:conf_dir]
  service 'monit' do
    action :nothing
  end

  template "#{node[:monit][:conf_dir]}/memcached.monitrc" do
    source 'memcached.monitrc.erb'
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, "service[monit]"
  end
end

if defined? node[:opsworks][:run_cookbook_tests]
  include_recipe 'memcached::prepare_tests' if node[:opsworks][:run_cookbook_tests]
end
