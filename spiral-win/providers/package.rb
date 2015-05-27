def initialize(*args)
  super
  @action = :install
end

action :install do

  log("Cygwin package: #{new_resource.name}")

  execute "install Cygwin package: #{new_resource.name}" do
    cwd "C:/tmp/spiralworks"
    command "setup.exe -q -O -R 'c:/cygwin' -s http://download.nus.edu.sg/mirror/cygwin/ -P #{new_resource.name}"
    not_if "c:/cygwin/bin/cygcheck -c #{new_resource.name}".include? "OK"
  end

  new_resource.updated_by_last_action(true)
end
