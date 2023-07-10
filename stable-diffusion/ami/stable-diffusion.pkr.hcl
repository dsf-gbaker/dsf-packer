packer {
  required_plugins {
    amazon = {
      version = "1.0.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami-name" {
  type = string
}

variable "ami-major-v" {
  type = string
}

variable "ami-minor-v" {
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

source "amazon-ebs" "stable-diffusion" {
  ami_name      = "${var.ami-name}-v${var.ami-major-v}.${var.ami-minor-v}"
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
  name = "${var.ami-name}"
  sources = [
    "source.amazon-ebs.stable-diffusion"
  ]

  # install application dependencies
  provisioner "shell" {
    script = "./scripts/install-deps.sh"
  }

  # set dir permissions
  /*
  provisioner "shell" {
    inline = [
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo chmod 2775 /var/www",
      "find /var/www -type d -exec sudo chmod 2775 {} \\;",
      "find /var/www -type f -exec sudo chmod 2775 {} \\;"
    ]
  }
  */
}
