default['phabricator']['username'] = 'devops'
default['phabricator']['email'] = 'devops@spiralwks.com'
default['phabricator']['password'] = 'spiralworks'

default['phabricator']['domain'] = 'phabricator.mtstein.net'

# user to own the checked out files
default['phabricator']['user'] = 'ubuntu'
# dir where phabricator and deps are installed
default['phabricator']['install_dir'] = '/home/ubuntu'

# ngix service name, maybe different on platforms
default['phabricator']['nginx']['service'] = 'nginx'

# phabricator config saved into conf/local/local.json
# see ./bin/config list for available configuration
default['phabricator']['config'] = {
    'environment.append-paths' => ['/usr/bin', '/usr/local/bin'],
    'phabricator.base-uri' => 'http://phabricator.mtstein.net',
# mysql connection params
    'mysql.host' => 'localhost',
    'mysql.port' => 3306,
    'mysql.user' => 'root',
    'mysql.pass' => ''
}
