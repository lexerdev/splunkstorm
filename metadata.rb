maintainer       "Aaron Wallis"
maintainer_email "aaron.wallis@lexer.com.au"
license          "Apache 2.0"
description      "Installs/Configures Splunk Storm forwarders"
long_description IO.read(File.join(File.dirname(__FILE__), 'readme.md'))
version          "0.0.3"
%w{redhat centos fedora debian ubuntu}.each do |os|
  supports os
end
