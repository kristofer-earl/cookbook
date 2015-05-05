#
include_recipe 'php5-fpm'

package 'php5' do
	action :install
end