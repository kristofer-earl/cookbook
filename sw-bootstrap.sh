#!/bin/bash
#bootstrap script for
apt-get update
apt-get upgrade -y
apt-get install curl -y
curl -L https://www.opscode.com/chef/install.sh | bash
wget http://github.com/opscode/chef-repo/tarball/master
tar -zxf master
mv chef-chef-repo* chef-repo
rm -rf master
mkdir chef-repo/.chef
curd=$(pwd)
echo "cookbook_path [ '$curd/chef-repo/cookbooks' ]" > chef-repo/.chef/knife.rb
printf "file_cache_path \"$curd/chef-solo\"\ncookbook_path \"$curd/chef-repo/cookbooks\"" > chef-repo/solo.rb
echo "{ \"run_list\": [ \"recipe[prometheus::dev]\" ]}" > chef-repo/default.json
cd chef-repo/
rm -rf cookbooks
mv ../Yggdrasil cookbooks
chef-solo -c solo.rb -j default.json
