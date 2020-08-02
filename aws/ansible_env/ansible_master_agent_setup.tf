provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ansible_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "image-id"
    values = ["ami-0d03e44a2333dea65"]
  }
}

resource "aws_security_group" "ansible_sg_tf" {
  name        = "ansible_sg"
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
    Name = "ansible_sg_tf"
  }
}

resource "aws_instance" "ansible_agent" {
  ami             = data.aws_ami.ansible_ami.id
  instance_type   = "t2.medium"
  security_groups = ["${aws_security_group.ansible_sg_tf.name}"]
  key_name        = "aws-default-pair"
  tags = {
    Name = "ansible_agent"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 25
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("~/.aws/my_aws_pems/aws-default-pair.pem")
  }
  provisioner "file" {
    source      = "~/.ssh/ansible_master.pub"
    destination = "/home/ubuntu/.ssh/ansible_master.pub"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo echo /home/ubuntu/.ssh/ansible_master.pub >> /home/ubuntu/authorized_keys",
      "sudo rm -f /home/ubuntu/.ssh/ansible_master.pub"
    ]
  }
}

resource "aws_instance" "ansible_master" {
  ami             = data.aws_ami.ansible_ami.id
  instance_type   = "t2.medium"
  security_groups = ["${aws_security_group.ansible_sg_tf.name}"]
  key_name        = "aws-default-pair"
  user_data       = file("./apt/user_data_master.sh")
  tags = {
    Name = "ansible_master"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 25
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("~/.aws/my_aws_pems/aws-default-pair.pem")
  }
  provisioner "file" {
    source      = "~/.ssh/ansible_master"
    destination = "/home/ubuntu/.ssh/ansible_master"
  }
  provisioner "file" {
    source      = "~/.ssh/ansible_master.pub"
    destination = "/home/ubuntu/.ssh/ansible_master.pub"
  }
  provisioner "file" {
    source      = "./apt/setup_ansible_master.sh"
    destination = "/tmp/setup_ansible_master.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/setup_ansible_master.sh",
      "sudo /tmp/setup_ansible_master.sh ${aws_instance.ansible_agent.public_ip}"
    ]
  }
}

output "ami_id" {
  value = "${data.aws_ami.ansible_ami.id}"
}

output "ansible_master_ip" {
  value = "${aws_instance.ansible_master.public_ip}"
}

output "ansible_agent_ip" {
  value = "${aws_instance.ansible_agent.public_ip}"
}

output "ansible_sg_id" {
  value = "${aws_security_group.ansible_sg_tf.id}"
}

resource "aws_security_group_rule" "open_8140" {
  type      = "ingress"
  to_port   = 22
  from_port = 22
  protocol  = "tcp"
  cidr_blocks = ["${aws_instance.ansible_master.public_ip}/32"]
  security_group_id = aws_security_group.ansible_sg_tf.id
  description       = "created via my_terraform repo. open for master particularly"
}
