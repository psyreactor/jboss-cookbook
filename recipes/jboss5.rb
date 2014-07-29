# Encoding: utf-8
#
# Cookbook Name:: jboss
# Recipe:: jboss5
#
# Copyright 2014, Mariani Lucas
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

unless node.recipe?('jboss::default')
  Chef::Log.info('Using jboss::default instead is recommended.')
end

Chef::Log.info('Instalin Jboss 5 EAP.')

version_pkg = node[:jboss][:version].split('.').first(2).join('.')

package 'install_unzip' do
  package_name 'unzip'
  action :install
end

user node[:jboss][:jboss_user] do
  action :create
end

group node[:jboss][:jboss_group] do
  action :create
  members node[:jboss][:jboss_user]
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:jboss][:filename]}.zip" do
  source node[:jboss][:package_url]
  checksum node[:jboss][:checksum]
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

execute 'jboss_extract' do
  user 'root'
  cwd Chef::Config[:file_cache_path]
  command "unzip -o #{node[:jboss][:filename]}.zip"
  action :run
end

execute 'jboss_install_path' do
  user 'root'
  cwd Chef::Config[:file_cache_path]
  command "mv jboss-eap-#{version_pkg}/jboss-as #{node[:jboss][:install_path]}"
  action :run
  not_if { ::Dir.exist?("#{node[:jboss][:install_path]}/jboss-as") }
end

execute 'create_profile' do
  user 'root'
  cwd node[:jboss][:install_path]
  command "cp -R #{node[:jboss][:install_path]}/jboss-as/server/default #{node[:jboss][:install_path]}/jboss-as/server/#{node[:jboss][:application]}"
  action :run
  not_if { ::Dir.exist?("#{node[:jboss][:install_path]}/jboss-as/server/#{node[:jboss][:application]}") }
end

execute 'jboss_owner' do
  user 'root'
  cwd node[:jboss][:install_path]
  command "chown -R #{node[:jboss][:jboss_user]}. jboss-as"
  action :run
end

directory '/etc/jboss-as' do
  owner node[:jboss][:jboss_user]
  group node[:jboss][:jboss_group]
  mode '0755'
end

directory '/var/run/jboss-as' do
  owner node[:jboss][:jboss_user]
  group node[:jboss][:jboss_group]
  mode '0755'
end

template "#{node[:jboss][:install_path]}/jboss-as/server/#{node[:jboss][:application]}/conf/run.conf" do
  source 'jboss5-run.conf.erb'
  owner node[:jboss][:jboss_user]
  group node[:jboss][:jboss_group]
  mode '0755'
end

link "/etc/jboss-as/#{node[:jboss][:application]}" do
  to "#{node[:jboss][:install_path]}/jboss-as/server/#{node[:jboss][:application]}/conf"
  owner node[:jboss][:jboss_user]
  group node[:jboss][:jboss_group]
  not_if "test -h /etc/jboss-as/#{node[:jboss][:application]}"
end

link node[:jboss][:log_dir] do
  action :delete
  only_if "test -h #{node[:jboss][:log_dir]}"
end

directory node[:jboss][:log_dir] do
  recursive true
  owner node[:jboss][:jboss_user]
  group node[:jboss][:jboss_group]
  mode '0775'
end

directory "#{node[:jboss][:install_path]}/jboss-as/server/#{node[:jboss][:application]}/log" do
  recursive true
  action :delete
  not_if { node[:jboss][:log_dir] == "#{node[:jboss][:install_path]}/jboss-as/server/#{node[:jboss][:application]}/log" }
  not_if "test -h #{node[:jboss][:install_path]}/jboss-as/server/#{node[:jboss][:application]}/log"
end

link "#{node[:jboss][:install_path]}/jboss-as/server/#{node[:jboss][:application]}/log" do
  to node[:jboss][:log_dir]
  owner node[:jboss][:jboss_user]
  group node[:jboss][:jboss_group]
  not_if { node[:jboss][:log_dir] == "#{node[:jboss][:install_path]}/jboss-as/server//#{node[:jboss][:application]}/log" }
  not_if "test -h #{node[:jboss][:install_path]}/jboss-as/server/#{node[:jboss][:application]}/log"
end

service node[:jboss][:application] do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :nothing
end

template "/etc/init.d/#{node[:jboss][:application]}" do
  source 'jboss5-as-init.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :enable, "service[#{node[:jboss][:application]}]"
  notifies :start, "service[#{node[:jboss][:application]}]"
end
