provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "puppet_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64*"]
  }
}

resource "aws_security_group" "puppet_sg_tf" {
  name        = "puppet_sg"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "ssh connectivity"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["107.141.33.229/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "puppet_sg_tf"
  }
}

resource "aws_instance" "puppet_master" {
    ami = data.aws_ami.puppet_ami.id
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.puppet_sg_tf.name}"]
    key_name = "aws-default-pair"

    tags = {
        Name = "puppet_master"
    }
}
resource "aws_instance" "puppet_agent" {
    ami = data.aws_ami.puppet_ami.id
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.puppet_sg_tf.name}"]
    key_name = "aws-default-pair"

    tags = {
        Name = "puppet_agent"
    }
}

output "ami_id" {
  value = "${data.aws_ami.puppet_ami.id}"
}

output "puppet_master_ip" {
    value = "${aws_instance.puppet_master.public_ip}"
}

output "puppet_agent_ip" {
    value = "${aws_instance.puppet_agent.public_ip}"
}
