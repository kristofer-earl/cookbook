default[:prometheus][:cms][:db_host] = 'localhost'
default[:prometheus][:cms][:db_name] = 'cms'
default[:prometheus][:cms][:db_port] = '3306'
default[:prometheus][:cms][:db_user] = 'root'
default[:prometheus][:cms][:db_pass] = ''
default[:prometheus][:cms][:db_driver] = 'mysql'
default[:prometheus][:cms][:db_prefix] = ''

default[:prometheus][:cms][:fqdn] = 'localhost'
default[:prometheus][:cms][:int_fqdn] = 'cms1.localdomain'
default[:prometheus][:web][:fqdn] = 'localhost'
default[:prometheus][:api][:fqdn] = 'localhost'
default[:prometheus][:api][:int_fqdn] = 'api1.localdomain'

default[:prometheus][:api][:bo_endpoint] = 'http://ws.aqzbouat.com'
default[:prometheus][:api][:bo_payment_endpoint] = 'http://paymentservices.aqzbouat.com'
default[:prometheus][:api][:bo_msgservice_endpoint] = 'http://msgservices.aqzbouat.com'
default[:prometheus][:api][:bo_payment_endpoint] = 'http://paymentservices.aqzbouat.com'
default[:prometheus][:api][:bo_affiliate_endpoint] = 'http://affiliateservices.aqzbouat.com'

default[:prometheus][:env] = 'localdev'

default[:prometheus][:handle_ssl] = 'false'
default[:prometheus][:force_ssl] = 'false'
default[:prometheus][:enable_cors] = 'false'
default[:prometheus][:pagespeed] = 'false'

# debug /development mode options
default[:prometheus][:debug] = 'false'

# payment providers
default[:prometheus][:api][:daddy_pay_endpoint] = '' 
