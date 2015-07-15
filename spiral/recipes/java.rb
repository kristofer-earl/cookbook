include_recipe 'apt'
include_recipe 'spiral::default'

execute 'add_webupd8_java_ppa' do
  command '/usr/bin/apt-add-repository ppa:webupd8team/java && /usr/bin/apt-get update'
end

execute 'accept_oracle_license' do
  command 'echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections'
end

package 'oracle-java7-installer'
package 'oracle-java7-unlimited-jce-policy'
package 'oracle-java7-set-default'
