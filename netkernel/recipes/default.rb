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

include_recipe "netkernel::install"

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
  notifies :restart, "service[apache]"
end

user node[:netkernel][:user] do
  comment "NetKernel"
  system true
  shell "/bin/false"
  home node[:netkernel][:install_path]
end

# Setup init scripts and configure service

init_script = value_for_platform(
  ["centos", "redhat", "suse", "fedora" ] => {
    "default" => "/etc/init.d/netkernel"
  },
  ["ubuntu", "debian"] => {
    "default" => "/etc/init/netkernel.conf"
  }
)

template init_script do
  source "init_script.erb"
  mode "0755"
  owner "root"
  group "root"
end

template "/etc/default/netkernel" do
  source defaults.erb
  mode "0644"
  owner "root"
  group "root"
end

# Setup and manage log directory under /var/log, linked to INSTALL/log

log_link = File.absolute_path(File.join(node[:netkernel][:install_path], "log"))

directory node[:netkernel][:log_path] do
  owner node[:netkernel][:user]
  mode "0755"
end

unless log_link == node[:netkernel][:log_path]
  directory log_link do
    action :delete
    not_if do File.symlink? log_link end
  end
  
  link log_link do
    to node[:netkernel][:log_path]
  end
end

# Start service

service "netkernel" do
  supports [:restart, :status]
  action [:enable, :start]
end

