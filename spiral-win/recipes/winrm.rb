execute 'winrm-prep' do
  command 'winrm set winrm/config/service @{AllowUnencrypted = "true" } & winrm set winrm/config/service/auth @{Basic = "true" }'
end

execute 'open-firewall' do 
  guard_interpreter :powershell_script
  command 'netsh advfirewall firewall add rule name="default WinRM" dir=in protocol=TCP localport=5985 action=allow'
  only_if '(!(Get-NetFirewallRule | Where DisplayName -eq "default WinRM"))'
end
