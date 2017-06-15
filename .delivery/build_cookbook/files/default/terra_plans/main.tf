provider "openstack" {
  user_name   = ""
  tenant_name = ""
  password    = ""
  auth_url    = ""
}

resource "openstack_compute_instance_v2" "terraform" {
  name = "terraform"
  count = 1
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  key_pair = "jmiller"
  network {
    name = "public"
  }

  connection {
    user     = "ubuntu"
    private_key = "${file("/var/opt/delivery/workspace/automate-server.test/brewinc/breworg/mysql-server/master/acceptance/provision/repo/.delivery/build_cookbook/files/default/keys/jmiller")}"
  }

  provisioner "local-exec" {
    command = "berks package --berksfile=./Berksfile && mv cookbooks-*.tar.gz cookbooks.tar.gz"
  }

  provisioner "file" {
    source      = "cookbooks.tar.gz"
    destination = "/tmp/cookbooks.tar.gz"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -LO https://www.chef.io/chef/install.sh && sudo bash ./install.sh",
      "sudo chef-solo --recipe-url /tmp/cookbooks.tar.gz -o 'recipe[mysql-server::default]'"
    ]
  }
}
