include_recipe 'spiral-win::cygwin'

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
