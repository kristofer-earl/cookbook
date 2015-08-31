# Phabricator
Chef cookbook to install Phabricator.

#all required packages are included in the default recipe except for git.

Usage Steps (Vagrantfile):

git clone git://github.com:MainSystemDev/Yggdrasil.git

cd Yggdrasil/phabricator

Vagrant up


To access:

add entry to hostfile

127.0.0.1 phabricator.local

go to: http://phrabricator.local:8080/


login using:

Username: Admin

Password: changeme
