packer {
  required_plugins {
    amazon = {
      version = "1.0.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "wordpress-major-v" {
  type = string
}

variable "wordpress-minor-v" {
  type = string
}

variable "region" {
  type = string
}

variable "instance-type" {
  type = string
}

variable "ami-source" {
  type = string
}

variable "ssh-user" {
  type = string
}

variable "root-ebs-size" {
  type = number
}

source "amazon-ebs" "wordpress" {
  ami_name      = "wordpress-v${var.wordpress-major-v}.${var.wordpress-minor-v}"
  instance_type = "${var.instance-type}"
  region        = "${var.region}"
  source_ami    = "${var.ami-source}"
  ssh_username  = "${var.ssh-user}"

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = var.root-ebs-size
    volume_type = "gp2"
    delete_on_termination = true
  }
}

build {
  name = "wordpress"
  sources = [
    "source.amazon-ebs.wordpress"
  ]

  # install application dependencies
  provisioner "shell" {
    script = "./scripts/install-deps.sh"
  }

  # create the wordpress directories
  provisioner "shell" {
    inline = [
      "echo -- Create Wordpress Data Directory",
      "sudo mkdir -p /wordpress/data"
    ]
  }

  # set wordpress dir permissions
  provisioner "shell" {
    inline = [
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo chmod 2775 /var/www",
      "find /var/www -type d -exec sudo chmod 2775 {} \\;",
      "find /var/www -type f -exec sudo chmod 2775 {} \\;"
    ]
  }
}
