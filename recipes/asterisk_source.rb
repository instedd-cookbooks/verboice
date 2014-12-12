include_recipe "build-essential"

version = node['verboice']['asterisk']['version']
tar_file_name = "certified-asterisk-#{version}-current.tar.gz"
url = "http://downloads.asterisk.org/pub/telephony/certified-asterisk/#{tar_file_name}"

remote_file "#{Chef::Config[:file_cache_path]}/#{tar_file_name}" do
  source url
  not_if "which asterisk"
end

bash 'build asterisk' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  tar -zxf #{tar_file_name}
  (cd certified-asterisk-#{version}* && ./configure --disable-xmldoc)
  (cd certified-asterisk-#{version}* && make && make install config)
  EOF
  not_if "which asterisk"
end
