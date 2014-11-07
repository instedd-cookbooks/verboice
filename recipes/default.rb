package "git"
package "libzmq-dev"
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
  server_name "verboice-new.instedd.org"
  config_files %w(asterisk.yml credentials.yml nuntium.yml oauth.yml verboice.config verboice.yml database.yml)
end

directory "#{app_dir}/shared/data" do
  owner node['current_user']
  group node['current_user']
end
