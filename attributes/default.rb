
default[:jboss][:version] = '6.2.0'
default[:jboss][:install_path] = '/opt'
default[:jboss][:application] = 'app'
default[:jboss][:url] = 'http://localhost.com'
default[:jboss][:filename] = "jboss-eap-#{node[:jboss][:version]}"
default[:jboss][:package_url] = "#{node[:jboss][:url]}/#{node[:jboss][:filename]}.zip"
default[:jboss][:checksum] = '73c542c2e7f1102a3b51ab62e14023bcda227e737233327d2f17aa361c9ff05c'
default[:jboss][:log_dir] = "/var/log/jboss-as/#{node[:jboss][:application]}"
default[:jboss][:jboss_user] = 'jboss'
default[:jboss][:jboss_group] = 'jboss'
default[:jboss][:admin_user] = 'admin'
default[:jboss][:admin_passwd] = 'password'
default[:jboss][:startup_wait] = 30
default[:jboss][:shutdown_wait] = 30
default[:jboss][:java_home] = nil
default[:jboss][:java_opts] = '-Xms1303m -Xmx1303m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true'
default[:jboss][:preserve_java_opts] = false
default[:jboss][:port_offset] = 0
default[:jboss][:config] = 'standalone'
