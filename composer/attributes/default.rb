#
# Cookbook Name:: composer
# Attributes:: default
#
# Copyright 2012-2014, Escape Studios
#

<<<<<<< HEAD
# include_attribute 'php'
=======
#include_attribute 'php'
>>>>>>> a65af26f71a969d1305a5c7c7c07eaee3f14b675

if node['platform'] == 'windows'
  default['composer']['url'] = 'https://getcomposer.org/Composer-Setup.exe'
  default['composer']['install_dir'] = 'C:\\ProgramData\\ComposerSetup'
  default['composer']['bin'] = "#{node['composer']['install_dir']}\\composer.bat"
else
  default['composer']['url'] = 'http://getcomposer.org/composer.phar'
  default['composer']['install_dir'] = '/usr/local/bin'
  default['composer']['bin'] = "#{node['composer']['install_dir']}/composer"
  default['composer']['install_globally'] = true
  default['composer']['mask'] = 0755
  default['composer']['link_type'] = :symbolic
end

default['composer']['global_configs'] = {}
default['composer']['home_dir'] = nil
default['composer']['php_recipe'] = 'php::default'
