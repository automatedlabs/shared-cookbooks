default[:netkernel][:version] = "4.1.1"
default[:netkernel][:install_url] = "http://apposite.netkernel.org/dist/1060-NetKernel-SE/1060-NetKernel-SE-4.1.1.jar"
default[:netkernel][:java_opts] = "-Xmx128m -Xms128m -XX:SoftRefLRUPolicyMSPerMB=100"

# unattended.install.directory - name of directory in which to install the NK distro (mandatory)
default[:netkernel][:install_path] = "/opt/netkernel"
# unattended.install.proxyHost - proxy server hostname (optional)
default[:netkernel][:proxy][:hostname] = nil
# unattended.install.proxyPort - proxy server port (optional)
default[:netkernel][:proxy][:port] = nil
# unattended.install.proxyUsername - proxy server username (optional)
default[:netkernel][:proxy][:username] = nil
# unattended.install.proxyPassword - proxy server password (optional)
default[:netkernel][:proxy][:password] = nil
# unattended.install.proxyNTDomain - NTLM proxy server domain name (optional)
default[:netkernel][:proxy][:domain] = nil
# unattended.install.proxyNTWorkstation - NTLM workstation name (optional)
default[:netkernel][:proxy][:computername] = nil
# unattended.install.expand - expand jarred modules (optional "true" - defaults to "false", not expanded)
default[:netkernel][:expand_jars] = true

