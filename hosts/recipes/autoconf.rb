#
# Cookbook Name:: hosts
# Recipe:: autoconf
#
# The MIT License
# Copyright (c) 2011 Automated Labs, LLC and contributors (see commits)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# If the app_environment attribute exists, filter by that, else get all nodes
if node.attribute? "app_environment"
  hosts_from_server = search(:node, "hostname:[* TO *] AND role:#{node['app_environment']}")
else
  hosts_from_server = search(:node, "*:*")
end

hosts_from_server.each do |host|
  # If the host is in the cloud, get the private ip
  if host.attribute? "cloud"
    ip_addr = host['cloud']['private_ips'][0]
  else
    ip_addr = host['ipaddress']
  end
  
  hosts_entry host['fqdn'] do
    ip ip_addr
    aliases [host['hostname']]
    comment "added by recipe[hosts::autoconf]"
  end

end
