maintainer        "NorthDocks UG"
maintainer_email  "info@northdocks.com"
license           "Apache 2.0"
description       "Installs and configures Jenkins (former Hudson)"
version           "0.1.0"

recipe "jenkins", "Installs and configures Jenkins"

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{ java apache2 }.each do |cb|
  depends cb
end
