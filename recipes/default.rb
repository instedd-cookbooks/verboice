package "git"
package "libzmq3-dev"
package "festival"
package "sox"
package "libsox-fmt-mp3"
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "instedd-common::passenger"
include_recipe "nodejs"
include_recipe "apache2::mod_proxy_http"

bash "install erlang" do
  code <<-EOF
    wget --no-check-certificate https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
    sudo dpkg -i erlang-solutions_1.0_all.deb
    sudo apt-get update
    sudo -E apt-get -y install erlang-ic=1:17.5.3 erlang-diameter=1:17.5.3 erlang-eldap=1:17.5.3 erlang-base=1:17.5.3 \
        erlang-crypto=1:17.5.3 erlang-runtime-tools=1:17.5.3 erlang-mnesia=1:17.5.3 erlang-ssl=1:17.5.3 \
        erlang-syntax-tools=1:17.5.3 erlang-asn1=1:17.5.3 erlang-public-key=1:17.5.3 erlang=1:17.5.3 erlang-dev=1:17.5.3 \
        erlang-appmon=1:17.5.3 erlang-common-test=1:17.5.3 erlang-corba=1:17.5.3 erlang-debugger=1:17.5.3 \
        erlang-dialyzer=1:17.5.3 erlang-edoc=1:17.5.3 erlang-erl-docgen=1:17.5.3 erlang-et=1:17.5.3 erlang-eunit=1:17.5.3 \
        erlang-gs=1:17.5.3 erlang-inets=1:17.5.3 erlang-inviso=1:17.5.3 erlang-megaco=1:17.5.3 erlang-observer=1:17.5.3 \
        erlang-odbc=1:17.5.3 erlang-os-mon=1:17.5.3 erlang-parsetools=1:17.5.3 erlang-percept=1:17.5.3 erlang-pman=1:17.5.3 \
        erlang-reltool=1:17.5.3 erlang-snmp=1:17.5.3 erlang-ssh=1:17.5.3 erlang-test-server=1:17.5.3 erlang-toolbar=1:17.5.3 \
        erlang-tools=1:17.5.3 erlang-tv=1:17.5.3 erlang-typer=1:17.5.3 erlang-webtool=1:17.5.3 erlang-wx=1:17.5.3 erlang-xmerl=1:17.5.3
  EOF
  not_if "which erl"
end

rbenv_ruby "1.9.3-p550"
rbenv_gem "bundler" do
  ruby_version "1.9.3-p550"
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
  config_files %w(credentials.yml nuntium.yml oauth.yml verboice.config verboice.yml database.yml poirot.yml guisso.yml hub.yml)
  passenger_spawn_method :conservative
  ssl node['verboice']['web']['ssl']['enabled']
  ssl_cert_file node['verboice']['web']['ssl']['cert_file']
  ssl_cert_key_file node['verboice']['web']['ssl']['cert_key_file']
  ssl_cert_chain_file node['verboice']['web']['ssl']['cert_chain_file']
  partials({"verboice/env.conf.erb" => { cookbook: "verboice" }})
  ssl_partials({"verboice/env.conf.erb" => { cookbook: "verboice" }})
  partials({"verboice/twilio_proxy.conf.erb" => { cookbook: "verboice" }})
  ssl_partials({"verboice/twilio_proxy.conf.erb" => { cookbook: "verboice" }})
end

directory "#{app_dir}/shared/data" do
  owner node['current_user']
  group node['current_user']
end

directory "#{node['verboice']['broker']['asterisk']['sounds_dir']}/verboice" do
  owner node['current_user']
  group node['current_user']
end

directory "/var/log/verboice" do
  owner node['current_user']
  group node['current_user']
end

newrelic_yml "#{app_dir}/shared/newrelic.yml" do
  agent_type 'ruby'
  app_name node['verboice']['newrelic']['app_name']
  license node['newrelic']['license']
  only_if { node['newrelic']['license'] }
end

logrotate_app "verboice" do
  path ["/var/log/verboice/*.log", "#{app_dir}/shared/log/*.log"]
  frequency :daily
  rotate 7
  options %w(missingok compress delaycompress notifempty copytruncate)
end
