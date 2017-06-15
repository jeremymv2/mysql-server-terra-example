# mysql-server

This cookbook demonstrates the use of Terraform in the build_cookbook's provision
phase to instantiate nodes for converging and running integration tests against.

# TODO
Secrets Management! - this is next highest priority.

# Setup
For now, use the delivery-truck and delivery-sugar cookbook repos below:

```bash
$ cat .delivery/build_cookbook/Berksfile
source 'https://supermarket.chef.io'

metadata

cookbook "delivery-truck", github: "jeremymv2/delivery-truck"
cookbook "delivery-sugar", github: "jeremymv2/delivery-sugar", branch: "jeremymv2/terraform"
cookbook 'test', path: './test/fixtures/cookbooks/test'
$
```

Add your terraform .tf files here:
```bash
$ ls -l .delivery/build_cookbook/files/default/terra_plans/
total 24
-rw-r--r--  1 jmiller  staff  1017 Jun 15 16:00 main.tf
-rw-r--r--  1 jmiller  staff    70 Jun 15 16:01 terraformvars.tf
-rw-r--r--  1 jmiller  staff   248 Jun 15 16:01 variable.tf
$
```

Put your ssh key here:
```bash
$ ls -l .delivery/build_cookbook/files/default/keys/
total 8
-rw-------  1 jmiller  staff  104 Jun 15 16:00 jmiller
$
```

Customize the build_cookbook attributes:
```bash
$ cat .delivery/build_cookbook/attributes/default.rb
default['terraform']['pin_version'] = '0.9.8'
default['terraform']['bin_path'] = '/usr/bin/terraform'
default['terraform']['source_url'] = 'https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip'
$
```

Terraform installation happens here:
```bash
$ cat .delivery/build_cookbook/recipes/default.rb
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
$
```

The provisioning happens here:
```bash
$ cat .delivery/build_cookbook/recipes/provision.rb
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
```
