include_recipe "build-essential"

version = node['verboice']['asterisk']['version']
tar_file_name = "asterisk-certified-#{version}-current.tar.gz"
url = "http://downloads.asterisk.org/pub/telephony/certified-asterisk/#{tar_file_name}"

bash 'build asterisk' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  mkdir asterisk-#{version}
  curl -s #{url} | tar -xvz --strip-components=1 -C asterisk-#{version}
  (cd asterisk-#{version}* && ./configure --disable-xmldoc)
  (cd asterisk-#{version}* && make menuselect.makeopts && make && make install config)
  EOF
  not_if "which asterisk"
end
