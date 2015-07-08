include_recipe 'elasticsearch'
include_recipe 'mongodb'
include_recipe 'graylog2::default'
include_recipe 'graylog2::server'
include_recipe 'graylog2::web'

package 'pwgen'
