include_recipe "consul"
consul_service_def "dummy" do
  id "uniqueid"
  action :delete
end
