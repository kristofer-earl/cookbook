#
# Cookbook Name:: percona
# Recipe:: package_repo
#

return unless node["percona"]["use_percona_repos"]

case node["platform_family"]
when "debian"
  include_recipe "apt"

  # Pin this repo as to avoid upgrade conflicts with distribution repos.
  apt_preference "00percona.pref" do
    glob "*"
    pin "release o=Percona Development Team"
    pin_priority "1001"
  end

  execute "add_percona_apt_key" do
    command "/usr/bin/apt-key add /usr/share/keyrings/percona.gpg"
    action :nothing
  end

  cookbook_file  "/usr/share/keyrings/percona.gpg" do
    mode "0644"
    owner "root"
    group "root"
    action :create
    backup false
    source  "percona.gpg"
    notifies :run, resources(:execute => "add_percona_apt_key")
  end

  apt_repository "percona" do
    uri node["percona"]["apt_uri"]
    distribution node["lsb"]["codename"]
    components ["main"]
  end

when "rhel"
  include_recipe "yum"

  yum_repository "percona" do
    description node["percona"]["yum"]["description"]
    baseurl node["percona"]["yum"]["baseurl"]
    gpgkey node["percona"]["yum"]["gpgkey"]
    gpgcheck node["percona"]["yum"]["gpgcheck"]
    sslverify node["percona"]["yum"]["sslverify"]
  end
end
