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

