provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "private-sg" {
  name = "my-SG"
  description = "HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-EC2" {
  ami = "ami-0e6329e222e662a52"
  instance_type = "t2.micro"
  key_name = "devops-test-key"
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
  tags = {
    Name = "Test-EC2"
  }
}

resource "aws_s3_bucket" "test-bucket" {
  bucket = "my-tf-test-bucket"
  acl    = "private"
  tags = {
    Name        = "devops-south-tst-buck"
  }
}
