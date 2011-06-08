
define :nk_instance, :enable => true, 
                     :version => "4.1.1",
                     :install_url => "http://apposite.netkernel.org/dist/1060-NetKernel-SE/1060-NetKernel-SE-4.1.1.jar",
                     :install_dir => "/opt/netkernel",
                     :nk_user => "netkernel" do

  include_recipe "java"

  temp_file = "/tmp/netkernel-#{params[:version]}.jar"

  log "nk_instance: NK installation not found... installing." do
    level :debug
    not_if { File.exists?( params[:install_dir] )}
    notifies :create, "remote_file[#{temp_file}]", :immediately
  end

  remote_file temp_file do
    source params[:install_dir]
    action :nothing
    notifies :run, "execute[install_nk:${params[:install_dir]}]", :immediately
  end

  execute "install_nk:${install_dir}" do
    command "java -Dunattended.install.directory=#{params[:install_dir]} -jar #{temp_file}"
    creates params[:install_dir]
    action :nothing
  end

end
                     
