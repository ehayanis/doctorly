provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "web-server" {
  vpc_security_group_ids = [
    aws_security_group.doctorly-backend-sg.id
  ]

  root_block_device {
    delete_on_termination = true
    iops = 150
    volume_size = 50
    volume_type = "gp2"
  }

  tags = {
    Name ="SERVER01"
    Environment = "DEV"
    OS = "UBUNTU"
  }

  depends_on = [ aws_security_group.web-SG ]

  ami           = "ami-2757f631"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install ansible",
      "sudo systemctl start ansible",
    ]
  }

}

resource "aws_security_group" "doctorly-backend-sg" {
  name = "web-SG"
  description = "Web Security Group"
  vpc_id = "vpc-43219D"

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = ""
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "ec2-public-ip" {
  value = aws_instance.web-server.public_ip
}