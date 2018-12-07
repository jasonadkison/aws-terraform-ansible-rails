variable "public_key" {}
provider "aws" {}

resource "aws_key_pair" "hello_rails_key" {
  key_name = "hello-rails"
  public_key = "${file("${var.public_key}")}"
}

resource "aws_security_group" "allow_all" {
  name = "allow_all"
  description = "Allow all inbound and outbound"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "hello_rails"
  }
}

resource "aws_instance" "hello_rails" {
  ami = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.hello_rails_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]

  user_data = "${file("scripts/install_python.sh")}"

  tags {
    Name = "HelloRails"
  }
}

data "template_file" "hosts" {
  template = "${file("templates/hosts.cfg")}"
  depends_on = ["aws_instance.hello_rails"]
  vars {
    rails_public_ip = "${aws_instance.hello_rails.public_ip}"
  }
}

resource "null_resource" "hosts" {
  triggers {
    template_rendered = "${data.template_file.hosts.rendered}"
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.hosts.rendered}' > ../ansible/inventories/hosts"
  }
}

output "public_ip" {
  value = "${aws_instance.hello_rails.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.hello_rails.public_dns}"
}
