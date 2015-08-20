#
# Cookbook Name:: spiral-win
# Recipe:: iis
#
# Copyright 2015, SpiralWorks
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs IIS - Web Server (Windows Feature)
# Old Powershell script

WindowsFeatures = ["Web-Server",
		"Web-Common-Http",
		"Web-AppInit",
		"Web-Net-Ext45",
		"Web-Asp-Net45",
		"Web-Includes",
		"Web-WebSockets"]

WindowsFeatures.each do |wf|

   powershell_script "Install-WindowsFeature #{wf}" do
     code "Install-WindowsFeature -Name #{wf}"
#     guard_interpreter :powershell_script
     only_if "(Get-WindowsFeature -Name #{wf} | Where InstallState -Like 'Installed') -eq $null"
   end

end

powershell_script "remove default iis files" do
     code "Remove-Item 'C:\inetpub\wwwroot\*' -Force -Recurse	
     action :run
end

template "C:\\inetpub\\wwwroot\\lb.html" do
     source "lb.html.erb"
     action :create_if_missing
end
