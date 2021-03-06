include_recipe "verboice::pjproject_source"
include_recipe "verboice::asterisk_source"

service "asterisk" do
  supports :restart => true, :reload => true, :status => :true, :debug => :true,
    "logger-reload" => true, "extensions-reload" => true,
    "restart-convenient" => true, "force-reload" => true
  action :enable
end

if node['verboice']['asterisk']['local_networks'].empty?
  node['network']['interfaces'].each do |name, iface|
    iface['addresses'].each do |addr, addr_props|
      if addr_props['family'] == 'inet'
        node.default['verboice']['asterisk']['local_networks'] << "#{addr}/#{addr_props['prefixlen']}"
      end
    end
  end
end

config_files = %w(extensions.conf cli_aliases.conf logger.conf manager.conf modules.conf pjsip.conf) + %w(cdr.conf cel.conf dnsmgr.conf ari.conf voicemail.conf)
default_files = %w(acl.conf features.conf indications.conf pjproject.conf)
verboice_files = %w(pjsip_verboice.conf)

config_files.each do |config_file|
  template "/etc/asterisk/#{config_file}" do
    source "asterisk/#{config_file}.erb"
    notifies :restart, 'service[asterisk]'
    variables params: node['verboice']['asterisk']
  end
end

verboice_files.each do |verboice_file|
  file "/etc/asterisk/#{verboice_file}" do
    action :create_if_missing
    notifies :restart, 'service[asterisk]'
    owner node['current_user']
    group node['current_user']
  end
end

ruby_block "remove default asterisk configuration" do
  block do
    must_restart = false
    (Dir.entries("/etc/asterisk") - config_files - verboice_files - default_files - %w(. ..)).each do |entry|
      FileUtils.rm_rf "/etc/asterisk/#{entry}"
      must_restart = true
    end
    resources(service: 'asterisk').run_action(:restart) if must_restart
  end
end

logrotate_app "asterisk" do
  path "/var/log/asterisk/full"
  frequency :weekly
  rotate 11
  create '644 root adm'
  options %w(missingok compress delaycompress notifempty)
  postrotate "/usr/sbin/asterisk -rx 'logger reload' > /dev/null 2> /dev/null"
end
