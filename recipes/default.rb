package "git"
package "libzmq-dev"
package "festival"
include_recipe "erlang"
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "instedd-common::passenger"
include_recipe "nodejs"

rbenv_ruby "1.9.3-p484"
rbenv_gem "bundler" do
  ruby_version "1.9.3-p484"
end

include_recipe "mysql::client"
include_recipe "database::mysql"

mysql_connection = {
  host: node['mysql']['server_host'],
  username: node['mysql']['admin_username'] || 'root',
  password: node['mysql']['admin_password'] || node['mysql']['server_root_password']
}

mysql_database "verboice" do
  connection mysql_connection
end

app_dir = "/u/apps/verboice"

rails_web_app "verboice" do
  server_name node['verboice']['host_name']
  config_files %w(credentials.yml nuntium.yml oauth.yml verboice.config verboice.yml database.yml poirot.yml guisso.yml)
  passenger_spawn_method :conservative
  ssl node['verboice']['web']['ssl']['enabled']
  ssl_cert_file node['verboice']['web']['ssl']['cert_file']
  ssl_cert_key_file node['verboice']['web']['ssl']['cert_key_file']
  ssl_cert_chain_file node['verboice']['web']['ssl']['cert_chain_file']
  ssl_env_vars({
    "INSTEDD_THEME" => node['verboice']['web']['ssl']['instedd_theme_url']
  })
end

directory "#{app_dir}/shared/data" do
  owner node['current_user']
  group node['current_user']
end

directory "#{node['verboice']['broker']['asterisk']['sounds_dir']}/verboice" do
  owner node['current_user']
  group node['current_user']
end
