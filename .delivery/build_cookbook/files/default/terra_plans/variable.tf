variable "image" {
default = "Ubuntu-14.04"
}

variable "flavor" {
default = "gp1.subsonic"
}

variable "ssh_key_file" {
default = "~/.ssh/id_rsa.terraform"
}

variable "ssh_user_name" {
default = "ubuntu"
}

variable "pool" {
default = "public"
}
