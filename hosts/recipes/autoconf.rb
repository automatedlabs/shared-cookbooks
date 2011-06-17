#
# Cookbook Name:: hosts
# Recipe:: autoconf
#
# The MIT License
# Copyright (c) 2011 Automated Labs, LLC
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

#remove the role condition if you don't care about staging vs prod
hosts_from_server = search(:node, "hostname:[* TO *] AND role:#{node[:app_environment]}")

entries = []
hosts_from_server.each do |host|
  entry = {:aliases => [host[:hostname]], :fqdn => host[:fqdn], :comment => 'autoconf'}
  #cloud based, seems ohai 0.6.4 has a 'cloud' flat info, no per-provider section
  #take first private. Change it if you want something else
  if host['cloud']
    entry[:ip] = host['cloud']['private_ips'][0]
    entries << entry
  end
end

entries.each do |entry|
  hosts_entry entry[:fqdn] do
    ip entry[:ip]
    aliases entry[:aliases]
    comment entry[:comment]
  end
end
