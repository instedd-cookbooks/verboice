include_recipe "build-essential"

bash "install pjproject prerequisites" do
  code <<-EOF
    sudo apt-get install -y pkg-config libncurses5-dev uuid-dev libjansson-dev libsqlite3-dev
  EOF
end

version = node['verboice']['pjproject']['version']
tar_file_name = "pjproject-#{version}.tar.bz2"
url = "http://www.pjsip.org/release/#{version}/#{tar_file_name}"

bash 'build pjproject' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  curl -s #{url} | tar -xj
  (cd pjproject-#{version} && ./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr CFLAGS='-O2 -DNDEBUG')
  (cd pjproject-#{version} && make dep && make && make install && ldconfig)
  EOF
  not_if { ::File.exists? "/usr/lib/libpj.so" }
end
