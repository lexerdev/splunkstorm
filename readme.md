Description
===========

This little Chef Cookbook provides recipes and definitions to install Splunk Forwarders and setup monitors for Splunk Storm.


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

_TODO_


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