#
# Cookbook:: build_cookbook
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'delivery-truck::default'

dl_path = "#{Chef::Config[:file_cache_path]}/terraform.zip"

remote_file dl_path do
  source node['terraform']['source_url']
  mode '0755'
end

package 'unzip'

execute 'unzip terraform' do
  command "unzip -o #{dl_path} -d /usr/bin"
  only_if { upgrade_needed? }
end
