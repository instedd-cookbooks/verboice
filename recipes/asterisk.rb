package "asterisk"

service "asterisk" do
  supports :restart => true, :reload => true, :status => :true, :debug => :true,
    "logger-reload" => true, "extensions-reload" => true,
    "restart-convenient" => true, "force-reload" => true
  action :enable
end


config_files = %w(dnsmgr.conf extensions.ael logger.conf manager.conf modules.conf sip.conf)
verboice_files = %w(sip_verboice_channels.conf sip_verboice_registrations.conf)

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
    (Dir.entries("/etc/asterisk") - config_files - verboice_files - %w(. ..)).each do |entry|
      FileUtils.rm_rf "/etc/asterisk/#{entry}"
      must_restart = true
    end
    resources(service: 'asterisk').run_action(:restart) if must_restart
  end
end
