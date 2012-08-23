#
# Copyright 2012, Aaron Wallis
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

def already_monitors_path?(file, path)
  open("#{node['splunkstorm']['forwarder_home']}/etc/apps/search/local/inputs.conf") { |f| f.grep(/[monitor:\/\/#{new_resource.path}]/) }
end

action :add do
  if !already_monitors_path?("#{node['splunkstorm']['forwarder_home']}/etc/apps/search/local/inputs.conf", new_resource.path)
    execute "splunk add monitor #{new_resource.path}" do
      action :run
    end
  end
end

action :remove do
  if already_monitors_path?("#{node['splunkstorm']['forwarder_home']}/etc/apps/search/local/inputs.conf", new_resource.path)
    execute "splunk remove monitor #{new_resource.path}" do
      action :run
    end
  end
end
