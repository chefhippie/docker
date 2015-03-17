#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2013-2014, Thomas Boerger <thomas@webhippie.de>
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

case node["platform_family"]
when "suse"
  include_recipe "zypper"

  zypper_repository node["docker"]["zypper"]["alias"] do
    uri node["docker"]["zypper"]["repo"]
    key node["docker"]["zypper"]["key"]
    title node["docker"]["zypper"]["title"]

    action [:add, :refresh]

    only_if do
      node["docker"]["zypper"]["enabled"]
    end
  end
when "debian"
  include_recipe "apt"

  apt_repository node["docker"]["apt"]["alias"] do
    uri node["docker"]["apt"]["repo"]
    distribution node["docker"]["apt"]["distribution"]
    components node["docker"]["apt"]["components"]
    keyserver node["docker"]["apt"]["keyserver"]
    key node["docker"]["apt"]["key"]
    source false

    action [:add, :refresh]

    only_if do
      node["docker"]["apt"]["enabled"]
    end
  end
end

node["docker"]["packages"].each do |name|
  package name do
    action :install
  end
end

group node["docker"]["group"] do
  members node["docker"]["users"]
  append true

  action :modify
end

template node["docker"]["sysconfig_file"] do
  source "sysconfig.conf.erb"
  owner "root"
  group "root"
  mode 0644

  variables(
    node["docker"]
  )

  notifies :restart, "service[docker]"
end

service "docker" do
  case node["platform"]
  when "ubuntu"
    provider Chef::Provider::Service::Upstart
  end

  service_name node["docker"]["service_name"]
  action [:enable, :start]
end
