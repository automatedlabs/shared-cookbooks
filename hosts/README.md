DESCRIPTION:
==

A definition that manages the /etc/hosts file. Responds to local emergency changes by parsing a local /etc/hosts.local file.

REQUIREMENTS:
==

Requires an OS that utilizes /etc/hosts

ATTRIBUTES:
==

USAGE:
==

````ruby
node "a_hostname" do
  ip "an_IP"
  comment "a commented string laid down inline with the host entry"
  aliases ["another hostname", "and_maybe_another"]
end

hosts_entry node['deploy']['host'] do
  ip node['deploy']['ip']
  aliases ["deploy"]
  comment "deploy server host"
````
