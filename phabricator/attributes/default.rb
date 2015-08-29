default['phabricator']['username'] = 'devops'
default['phabricator']['email'] = 'devops@spiralwks.com'
default['phabricator']['password'] = 'spiralworks'

default['phabricator']['domain'] = 'phabricator.local'
default['phabricator']['timezone'] = 'Asia/Manila'

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
    'phabricator.base-uri' => 'http://phabricator.local',
    'security.alternate-file-domain' => 'http://phabricator.local',
    'pygments.enabled' => 'true',
# mysql connection params
    'mysql.host' => 'localhost',
    'mysql.port' => 3306,
    'mysql.user' => 'root',
    'mysql.pass' => ''
}
