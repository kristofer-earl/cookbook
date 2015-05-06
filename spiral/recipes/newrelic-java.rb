include_recipe 'spiral::default'

newrelic_archive_url = 'https://oss.sonatype.org/content/repositories/releases/com/newrelic/agent/java/newrelic-java/3.15.0/newrelic-java-3.15.0.zip'

remote_file '/opt/nr-java.zip' do
  source newrelic_archive_url 
  not_if { ::File.exists?('/opt/nr-java.zip') }
end

execute 'extract_newrelic_java' do
  cwd     '/opt'
  command 'unzip /opt/nr-java.zip' 
  not_if { ::File.exists?('/opt/newrelic/newrelic.jar') }
end

cookbook_file '/opt/newrelic/newrelic.yml' do
  action :delete
end

template '/opt/newrelic/newrelic.yml' do
  source 'newrelic.yml.erb'
  owner  'root'
  group  'root'
  mode   '0744'
  action :create
end
