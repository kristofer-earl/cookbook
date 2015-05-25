include_recipe 'spiral::phpfpm'
include_recipe 'zabbix::default'

package 'zabbix-server-mysql'
package 'zabbix-frontend-php'
