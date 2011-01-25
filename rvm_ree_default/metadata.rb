maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "http://www.agileweboperations.com/chef-rvm-ruby-enterprise-edition-as-default-ruby"
version          "0.0.1"

recipe "rvm_ree_default", "Installs RVM and REE and makes REE the default"

depends "build-essential"
%w{redhat centos fedora ubuntu}.each do |os|
  supports os
end
