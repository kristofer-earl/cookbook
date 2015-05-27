#
# Cookbook Name:: spiral-win
# Recipe:: TestRecipe
#
# Copyright 2015, SpiralWorks
#
# All rights reserved - Do Not Redistribute
#
# Used for testing

remote_file "C:\\tmp\\spiralworks\\setup.exe" do
  source 'http://cygwin.com/setup-x86_64.exe'
  action :create_if_missing
end

execute "setup.exe" do
  cwd "c:/tmp/spiralworks"
  command "setup.exe -q -O -R c:/cygwin -s http://download.nus.edu.sg/mirror/cygwin/"
  not_if {File.directory?('c:\cygwin')}
end

windows_path "c:/cygwin/bin".gsub( /\//, "\\") do
  action :add
end

pkgs = ["git","openssh","cygrunsrv","ruby"]
		
pkgs.each do |pkg|

   execute "cygwin #{pkg}" do
     cwd "c:/tmp/spiralworks"
     command "echo c:\\cygwin\\bin\\#{pkg}\*"
     not_if { ::File.exists?("c:\\cygwin\\bin\\#{pkg}.exe")}
#     not_if "powershell c:/cygwin/bin/cygcheck -c #{pkg} | select-string -pattern 'OK'"
   end

end

execute "cygwin capistrano" do
     cwd "c:/"
     environment ({'PATH' => '$PATH:.:/cygdrive/c/'})
     command "gem install capistrano"
     not_if { ::File.exists?("c:\\cygwin\\bin\\cap")}
end

powershell_script "move caps" do
     guard_interpreter :powershell_script
     code "Copy-Item C:\\opscode\\chef\\embedded\\bin\\cap\* C:\\cygwin\\bin\\"
     not_if "test-path C:\\cygwin\\bin\\cap"
#     not_if { ::File.exists?('c:\cygwin\bin\cap')}
end

#ssh-host-config
execute "install openssh server" do 
    guard_interpreter :powershell_script
    cwd 'c:\cygwin\bin'
    environment ({'PATH' => '$PATH:.:/cygdrive/c/cygwin/bin'})
    command "bash /usr/bin/ssh-host-config --yes --cygwin \"ntsec\" --user \"sshserver\" --pwd \"ssh$erver123\""
    not_if "Get-Process sshd"
end

#make sure user that runs the sshserver never expires
execute "net-user-no-expire" do
    command  "net user sshserver /expires:never /active:yes"
end

#run sshd using cygrunsrv
execute "cygrunsrv" do
    cwd 'c:\cygwin\bin' 
    environment ({'PATH' => '$PATH:.:/cygdrive/c/cygwin/bin'})
    command 'cygrunsrv -S sshd'
end

#add firewall rules to allow ssh on default ssh port
execute "open ssh port" do
    command 'netsh advfirewall firewall add rule name=\"sshport\" dir=in action=allow protocol=TCP localport=22'
    guard_interpreter :powershell_script
    only_if '(Show-NetFirewallRule | Where{$_.DisplayName -eq "sshport" -AND $_.enabled}) -eq $null' 
end
