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
  ami             = data.aws_ami.puppet_ami.id
  instance_type   = "t2.medium"
  security_groups = ["${aws_security_group.puppet_sg_tf.name}"]
  key_name        = "aws-default-pair"
  # user_data = file("puppet_server.sh")

  tags = {
    Name = "puppet_master"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 25
  }

}
resource "aws_instance" "puppet_agent" {
  ami             = data.aws_ami.puppet_ami.id
  instance_type   = "t2.medium"
  security_groups = ["${aws_security_group.puppet_sg_tf.name}"]
  key_name        = "aws-default-pair"
  # user_data = file("puppet_agent.sh")

  tags = {
    Name = "puppet_agent"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 25
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

output "puppet_sg_id" {
  value = "${aws_security_group.puppet_sg_tf.id}"
}

resource "aws_security_group_rule" "allow_8140" {
  type = "ingress"
  to_port = 8140
  from_port = 8140
  protocol = "tcp"
  cidr_blocks = ["${aws_instance.puppet_master.public_ip}/32", "${aws_instance.puppet_agent.public_ip}/32"]
  security_group_id = aws_security_group.puppet_sg_tf.id
  description = "created via my_terraform repo"
}