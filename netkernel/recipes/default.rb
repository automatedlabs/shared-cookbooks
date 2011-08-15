#
# Cookbook Name:: netkernel
# Recipe:: default
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

include_recipe "java"

installer = "/var/chef/downloads/netkernel-#{node[:netkernel][:version]}.jar"

install_cmd = []
install_cmd << "java"
install_cmd << "-Dunattended.install.directory=#{node[:netkernel][:install_path]}"
install_cmd << "-Dunattended.install.expand=true" if node[:netkernel][:expand_jars]
unless node[:netkernel][:proxy][:hostname].nil?
  install_cmd << "-Dunattended.install.proxyHost=#{node[:netkernel][:proxy][:hostname]}"
end
unless node[:netkernel][:proxy][:port].nil?
  install_cmd << "-Dunattended.install.proxyPort=#{node[:netkernel][:proxy][:port]}"
end
unless node[:netkernel][:proxy][:username].nil?
  install_cmd << "-Dunattended.install.proxyUsername=#{node[:netkernel][:proxy][:username]}"
end
unless node[:netkernel][:proxy][:password].nil?
  install_cmd << "-Dunattended.install.proxyPassword=#{node[:netkernel][:proxy][:password]}"
end
unless node[:netkernel][:proxy][:domain].nil?
  install_cmd << "-Dunattended.install.proxyNTDomain=#{node[:netkernel][:proxy][:domain]}"
end
unless node[:netkernel][:proxy][:computername].nil?
  install_cmd << "-Dunattended.install.proxyNTWorkstation=#{node[:netkernel][:proxy][:computername]}"
end
install_cmd << "-jar #{installer}"

directory "/var/chef/downloads" do
  action :create
end

remote_file installer do
  source node[:netkernel][:install_url]
  action :create
  notifies :run, "execute[install_nk:#{installer}]", :immediately
end

execute "install_nk:#{installer}" do
  command install_cmd.join(" ")
  action :nothing
end

jvm_settings = []
jvm_settings << "-Xms#{node[:netkernel][:starting_heap]}"
jvm_settings << "-Xmx#{node[:netkernel][:max_heap]}"
jvm_settings << node[:netkernel][:java_opts]
jvm_settings << "-Dnetkernel.http.frontend.port=#{node[:netkernel][:frontend][:port].to_s}"
jvm_settings << "-Dnetkernel.http.backend.address=#{node[:netkernel][:backend][:address].to_s}"
jvm_settings << "-Dnetkernel.http.backend.port=#{node[:netkernel][:backend][:port].to_s}"

file File.join(node[:netkernel][:install_path], "bin", "jvmsettings.cnf") do
  content jvm_settings.join(" ")
  mode "0644"
  owner "root"
  group "root"
end