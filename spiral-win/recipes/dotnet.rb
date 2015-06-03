#This recipe will be used to pass on Deployment Scripts on windows machine.

directory 'C:\spiralworks' do
  inherits false
  rights :read, "Everyone"
  rights :write, "Administrators"
  rights :full_control, "Administrators", :applies_to_children => true
  action :create
  guard_interpreter :powershell_script
  not_if 'Test-Path C:\spiralworks'
end

template 'C:\spiralworks\deploy.ps1' do
  source 'deploy.erb'
end

template 'C:\spiralworks\rollback.ps1' do
  source 'rollback.erb'
end

remote_file 'C:\AWSToolsAndSDKForNet.msi' do
  source 'http://sdk-for-net.amazonwebservices.com/latest/AWSToolsAndSDKForNet.msi'
end

windows_package 'aws_sdk' do
  action :install
  source 'C:\AWSToolsAndSDKForNet.msi'
end
