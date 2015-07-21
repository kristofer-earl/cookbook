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


TemplatesErb = ["deploy",
                "rollback",
                "winserv",
		"webapp"]

TemplatesErb.each do |tmp|
   template "C:\\spiralworks\\#{tmp}.ps1" do
     source "#{tmp}.erb"
   end
end

remote_file 'C:\AWSToolsAndSDKForNet.msi' do
  source 'http://sdk-for-net.amazonwebservices.com/latest/AWSToolsAndSDKForNet.msi'
end

windows_package 'aws_sdk' do
  action :install
  source 'C:\AWSToolsAndSDKForNet.msi'
end

user 'deploy' do
  username 'deploy'
  password 'M4k3itg00d4Sp1r4lw0rks'
  comment 'This is a deployer User'
  action :create
end

group "Administrators" do
  members ['deploy']
  append true
  action :modify
end
