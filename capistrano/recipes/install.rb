#
package 'ruby' do
        action :install
end

execute 'capistrano_install' do
        command 'gem install capistrano'
end
