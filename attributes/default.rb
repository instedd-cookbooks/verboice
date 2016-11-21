default['verboice']['broker']['agi_port'] = 19000
default['verboice']['broker']['bert_port'] = 9999
default['verboice']['broker']['asterisk']['sounds_dir'] = '/var/lib/asterisk/sounds'
default['verboice']['broker']['asterisk']['config_dir'] = '/etc/asterisk'
default['verboice']['broker']['asterisk']['agi_use_pipe_separator'] =  false
default['verboice']['attr_encrypted_key'] = 'super_secret'

default['verboice']['broker']['nuntium']['host'] = 'https://nuntium.instedd.org'
default['verboice']['broker']['nuntium']['account'] = 'instedd'
default['verboice']['broker']['nuntium']['application'] = 'verboice'
default['verboice']['broker']['nuntium']['password'] = ''

default['verboice']['broker']['httpd']['port'] = 8080

default['verboice']['oauth']['google']['api_key'] = ''
default['verboice']['oauth']['google']['api_secret'] = ''

default['verboice']['host_name'] = node['fqdn']
default['verboice']['from_email'] = 'verboice@instedd.org'

default['verboice']['poirot']['enabled'] = false
default['verboice']['poirot']['debug'] = false
default['verboice']['poirot']['server'] = ''
default['verboice']['poirot']['source'] = 'verboice-ui'
default['verboice']['poirot']['elasticsearch_url'] = ''

default['verboice']['guisso']['enabled'] = false
default['verboice']['guisso']['url'] = 'https://login.instedd.org'
default['verboice']['guisso']['client_id'] = ''
default['verboice']['guisso']['client_secret'] = ''

default['verboice']['web']['ssl']['enabled'] = false
default['verboice']['web']['ssl']['cert_file'] = nil
default['verboice']['web']['ssl']['cert_key_file'] = nil
default['verboice']['web']['ssl']['cert_chain_file'] = nil
default['verboice']['web']['ssl']['instedd_theme_url'] = nil # "https://theme.instedd.org"

default['verboice']['newrelic']['app_name'] = 'Verboice'

default['verboice']['hub']['enabled'] = false
default['verboice']['hub']['url'] = "http://hub.instedd.org/"
default['verboice']['hub']['token'] = ""
default['verboice']['hub']['connector_guid'] = ""

default['verboice']['telemetry']['enabled'] = false
default['verboice']['telemetry']['agent_host'] = "127.0.0.1"
default['verboice']['telemetry']['agent_port'] = 8089

default['verboice']['pjproject']['version'] = "2.5.5"
