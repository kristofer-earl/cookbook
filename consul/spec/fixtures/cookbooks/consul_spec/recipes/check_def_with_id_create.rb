include_recipe "consul"
consul_check_def "dummy name" do
  id "uniqueid"
  script "curl http://localhost:8888/health"
  interval "10s"
  ttl "50s"
  http "http://localhost:8888/health"
  notes "Blahblah"
end
