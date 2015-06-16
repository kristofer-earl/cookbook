directory 'C:\spiralworks' do
  inherits false
  rights :read, "Everyone"
  rights :write, "Administrators"
  rights :full_control, "Administrators", :applies_to_children => true
  action :create
  guard_interpreter :powershell_script
  not_if 'Test-Path C:\spiralworks'
end

template 'C:\spiralworks\winserv.ps1' do
  source 'winservice.erb'
end
