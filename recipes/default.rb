#
# Cookbook Name:: splunkstorm
# Recipe:: default
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

directory '/opt' do
  mode '0755'
  owner 'root'
  group 'root'
end

splunk_cmd = "#{node['splunkstorm']['forwarder_home']}/bin/splunk"
splunk_package_version = "splunkforwarder-#{node['splunkstorm']['forwarder_version']}-#{node['splunkstorm']['forwarder_build']}"

splunk_file = splunk_package_version + 
  case node['platform_family']
  when 'rhel'
    if node['kernel']['machine'] == 'x86_64'
      '-linux-2.6-x86_64.rpm'
    else
      '.i386.rpm'
    end
  when 'debian'
    if node['kernel']['machine'] == 'x86_64'
      '-linux-2.6-amd64.deb'
    else
      '-linux-2.6-intel.deb'
    end
    else
      raise "Unknown platform: #{node['platform_family']}"
  end

remote_file "/opt/#{splunk_file}" do
  source "#{node['splunkstorm']['forwarder_root']}/#{node['splunkstorm']['forwarder_version']}/universalforwarder/linux/#{splunk_file}"
  action :create_if_missing
end

package splunk_package_version do
  source "/opt/#{splunk_file}"
  case node['platform_family']
  when 'rhel'
    provider Chef::Provider::Package::Rpm
  when 'debian'
    provider Chef::Provider::Package::Dpkg
    else
      raise "Unknown platform: #{node['platform_family']}"
  end
end

execute "#{splunk_cmd} start --accept-license --answer-yes" do
  not_if do
    `#{splunk_cmd} status --accept-license | grep 'splunkd'`.chomp! =~ /^splunkd is running/
  end
end

execute "#{splunk_cmd} enable boot-start" do
  not_if do
    File.symlink?('/etc/rc4.d/S20splunk')
  end
end

service 'splunk' do
  action [ :nothing ]
  supports :status => true, :start => true, :stop => true, :restart => true
end

if node['splunkstorm']['license_file']
  # the license file location was specified by the node config
  license_file = node['splunkstorm']['license_file']
else
  # look up license file in data bag
  license_details = Chef::EncryptedDataBagItem.load(node['splunkstorm']['license_databag'], node['splunkstorm']['license_databag_item'])
  license_file = "#{node['splunkstorm']['forwarder_home']}/#{license_details['filename']}"
  ruby_block 'create storm certificates' do
    block do
      File.open(license_file, 'wb') do |file|
        file.write(license_details['data'].unpack('m').first)
      end
    end
    action :create
  end

  bash 'fix license' do
    user 'root'
    cwd "#{node['splunkstorm']['forwarder_home']}"
    code <<-EOH
      chown root:root #{license_file}
      chmod 0644 #{license_file}
    EOH
  end
end

splunk_password = node['splunkstorm']['auth'].split(':')[1]
execute "#{splunk_cmd} edit user admin -password #{splunk_password} -roles admin -auth admin:changeme && echo true > /opt/splunk_setup_passwd" do
  not_if do
    File.exists?('/opt/splunk_setup_passwd')
  end
end

execute "#{splunk_cmd} install app #{license_file} -auth #{node['splunkstorm']['auth']} && echo true > /opt/splunk_setup_license" do
  not_if do
    File.exists?('/opt/splunk_setup_license')
  end
end

template '/etc/init.d/splunk' do
  source 'splunk.erb'
  mode '0755'
  owner 'root'
  group 'root'
end

template '/etc/profile.d/splunk.sh' do
  source 'splunk.sh.erb'
  mode 0644
end
