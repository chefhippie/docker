#
# Cookbook Name:: docker
# Attributes:: default
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

default["docker"]["packages"] = value_for_platform_family(
  "debian" => %w(
    docker
  ),
  "ubuntu" => %w(
    docker
  ),
  "suse" => %w(
    docker
  )
)

default["docker"]["sysconfig_file"] = value_for_platform_family(
  "debian" => "/etc/default/docker",
  "ubuntu" => "/etc/default/docker",
  "suse" => "/etc/sysconfig/docker"
)

default["docker"]["service_name"] = "docker"
default["docker"]["daemon_opts"] = ""

default["docker"]["users"] = %w()
default["docker"]["group"] = "docker"

default["docker"]["zypper"]["enabled"] = true
default["docker"]["zypper"]["alias"] = "virtualization"
default["docker"]["zypper"]["title"] = "Virtualization"
default["docker"]["zypper"]["repo"] = "http://download.opensuse.org/repositories/Virtualization/openSUSE_#{node["platform_version"]}/"
default["docker"]["zypper"]["key"] = "#{node["docker"]["zypper"]["repo"]}repodata/repomd.xml.key"