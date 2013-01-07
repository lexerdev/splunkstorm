Description
===========

This little Chef Cookbook provides recipes and definitions to install Splunk Forwarders and setup monitors for Splunk Storm.

As you know, Splunk Storm uses a proprietary credentials file to setup access to the Splunk Storm servers/account.
You probably won't want to have this file floating around in your cookbook unencrypted, so we're going to stuff the contents of the credentials file into a Secure Databag.

To do that, you'll need to:

1. Create the data bag using knife
        
        knife data bag create licenses storm --secret-file ~/.chef/encrypted_data_bag_secret
2. Open `irb` from the directory containing your project certificate, and run the following script (make sure you update the variables to suit your setup)

        require 'base64'
        require 'chef'

        data_bag     = "licenses"
        data_bag_key = "storm"
        license_file = "stormforwarder_XXXXXXXX.spl"
         
        data = [File.open(license_file, "rb") {|io| io.read}].pack("m")
        data.gsub(/\n/, "\n")
3. Copy the string output by `irb`, and run the following command to edit the data bag, pasting the string into a JSON "data" field, and the license filename into a "filename" field.

        knife data bag edit licenses storm --secret-file ~/.chef/encrypted_data_bag_secret

4. Run `knife data bag show licenses storm --secret-file ~/.chef/encrypted_data_bag_secret` and confirm your data bag looks like something like this:

        {
            "id": "storm",
            "filename": {license file name},
            "data": {string created in irb}
        }
3. You'll probably want to check-in your databag into your SCM
        
        knife data bag show licenses storm -Fj > data_bags/licenses/storm.json

Changes
=======

* v0.0.1 - Initial Release


Current Bugs
============

* Very beta - only tested in Ubuntu 12.04


Requirements
============

## Platform:

* Ubuntu, Debian, RedHat, CentOS, Fedora

- This cookbook has only been tested thoroughly with Ubuntu


Attributes
==========

See `attributes/default.rb` for default values.

* `node['splunkstorm']['cookbook_name']` - The name of the directory in which the cookbook runs.
* `node['splunkstorm']['forwarder_home']` - The directory in which to install the Splunk Forwarder
* `node['splunkstorm']['auth']` - The default admin password to use instead of splunks "changeme"
* `node['splunkstorm']['forwarder_root']` - The base URL that splunk uses to download release files for Splunk Forwarder
* `node['splunkstorm']['forwarder_version']` - The specific version of Splunk Forwarder to download
* `node['splunkstorm']['forwarder_build]` - The specific build number of Splunk Forwarder to download


Recipes
=======

splunkstorm
-----

Installs Splunk Forwarder for Storm.
- You need to setup data bags with your Splunk Storm credentials. Check out this gist for details: https://gist.github.com/3384786

Usage
=====

## Splunk Storm Forwarder Install:

This will install the Splunk Forwarder:

    recipe[splunkstorm]


Resources and Providers
=======================

To add and remove monitors you can use the `splunkstorm_monitor` provider:
    
    include_recipe "splunkstorm"
    
    # monitor the log directory in Splunk Storm, with an additional parameter setting source type
    splunkstorm_monitor "/var/log" do
      path "/var/log/*.log"
      params "sourcetype" => "access_combined"
      action :add
    end
    
    # remove the log directory monitor in Splunk Storm
    splunkstorm_monitor "/var/log" do
      path "/var/log/*.log"
      action :remove
    end



License and Author
==================

Author:: Aaron Wallis (<aaron.wallis@lexer.com.au>)

Copyright 2012-2013, Lexer Pty Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.