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
<<<<<<< HEAD
echo "{ \"run_list\": [ \"recipe[prometheus::dev]\" ]}" > chef-repo/dev.json
echo "{ \"run_list\": [ \"recipe[prometheus::cms]\" ]}" > chef-repo/cms.json
echo "{ \"run_list\": [ \"recipe[prometheus::api]\" ]}" > chef-repo/api.json
echo "{ \"run_list\": [ \"recipe[prometheus::web]\" ]}" > chef-repo/web.json
echo "{ \"run_list\": [ \"recipe[capistrano::install]\" ]}" > chef-repo/cap.json
=======
echo "{ \"run_list\": [ \"recipe[prometheus::dev]\" ]}" > chef-repo/default.json
>>>>>>> a65af26f71a969d1305a5c7c7c07eaee3f14b675
cd chef-repo/
rm -rf cookbooks
mv ../Yggdrasil cookbooks
chef-solo -c solo.rb -j $1
