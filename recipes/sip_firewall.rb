include_recipe "iptables"

iptables_rule "ssh_firewall" do
  action :enable
end

iptables_rule "sip_firewall" do
  action :enable
end

