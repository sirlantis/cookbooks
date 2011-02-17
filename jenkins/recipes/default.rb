#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2010, NorthDocks
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node.platform
when "ubuntu"
  include_recipe "apt"
  include_recipe "java"

  package "curl"

  execute "curl http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -" do
    not_if "apt-key finger | grep '150F DE3F 7787 E7D1 1EF4  E12A 9B7D 32F2 D505 82E6'"
  end

  template "/etc/apt/sources.list.d/jenkins-ci.org.list" do
    mode "0644"
    source "jenkins-ci.org.list.erb"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
end

package "jenkins" do
  action :upgrade
end

service "jenkins" do
  supports [ :restart, :status ]
  action [ :enable, :start ]
end

template "/etc/default/jenkins" do
  mode "0644"
  source "default.erb"
  notifies :restart, resources(:service => "jenkins")
end

include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

template "#{node[:apache][:dir]}/sites-available/jenkins.conf" do
  source "apache2.conf.erb"
  owner "root"
  group "root"
  mode 0644

  variables(
    :endpoint => "http://localhost:#{node[:jenkins][:port]}"
  )

  if ::File.exists?("#{node[:apache][:dir]}/sites-enabled/jenkins.conf")
    notifies :reload, resources(:service => "apache2"), :delayed
  end
end

apache_site "jenkins"