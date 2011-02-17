
# general settings
default[:jenkins][:user]              = "jenkins"
default[:jenkins][:port]              = 8080

# apache proxy
default[:jenkins][:virtual_host_name] = "ci.#{node[:fqdn]}"
