#
# Cookbook Name:: graphite
# Attributes:: default
#
# Copyright (C) 2014, Chef Software, Inc <legal@getchef.com>
#

default['graphite']['carbon_cache']['enable'] = true

default['graphite']['carbon']['data_dir'] = '/var/lib/graphite/whisper/'
default['graphite']['carbon']['user'] = '_graphite'
default['graphite']['carbon']['host'] = '0.0.0.0'
default['graphite']['carbon']['port'] = '2003'

default['graphite']['web']['secret_key'] = '0aed5c39507562f4519c2d47515e8221'
default['graphite']['web']['time_zone'] = 'America/Los_Angeles'
default['graphite']['web']['server'] = 'uwsgi'
# This does not update after initial setup
default['graphite']['web']['seed_password'] = 'changeme'

# These defaults are over riddent in the _nginx recipe
default['graphite']['uwsgi']['listen_ip']   = '0.0.0.0'
default['graphite']['uwsgi']['listen_port'] = 8080

default['graphite']['nginx']['disable_default_vhost'] = false
# The template will use the host's FQDN unless this attribute is set
default['graphite']['nginx']['hostname'] = nil
