default['verboice']['broker']['port'] = 19000
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

default['verboice']['host_name'] = 'verboice.instedd.org'
default['verboice']['from_email'] = 'verboice@instedd.org'
