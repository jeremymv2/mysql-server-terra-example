#
# Cookbook:: build_cookbook
# Recipe:: provision
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'delivery-truck::provision'

params = { bin_path: node['terraform']['bin_path'],
           plan_dir: "#{delivery_workspace_repo}/.delivery/build_cookbook/files/default/terra_plans" }

delivery_terraform 'ubuntu1404' do
  bin_path params[:bin_path]
  plan_dir params[:plan_dir]
end
