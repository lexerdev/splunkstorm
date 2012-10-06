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

def input_path
  "#{node['splunkstorm']['forwarder_home']}/etc/apps/search/local/inputs.conf"
end

def already_monitors_path?(path)
  status = false
  if FileTest.exists?(input_path())
    if IO.read(input_path()) =~ /\[monitor\:\/\/#{Regexp.escape(path)}\]/
      status = true
    end
  end
  
  status
end

action :add do
  if !already_monitors_path?(new_resource.path)
    execute "#{node['splunkstorm']['forwarder_home']}/bin/splunk add monitor #{new_resource.path}" do
      action :run
    end
  end
end

action :remove do
  if already_monitors_path?(new_resource.path)
    execute "#{node['splunkstorm']['forwarder_home']}/bin/splunk remove monitor #{new_resource.path}" do
      action :run
    end
  end
end
