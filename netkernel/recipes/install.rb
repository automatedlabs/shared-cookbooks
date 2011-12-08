
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
