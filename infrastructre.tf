provider "aws" {
  region     = "eu-north-1"
  access_key = "AKIAW55KAGIJV4XZDAKP"
  secret_key = "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"
}

resource "aws_subnet" "Sidsub" {
  vpc_id     = "vpc-0f4ab63efa2fc856f"
  cidr_block = "172.31.100.0/24"
  tags = {
    Name = "Sidali_subnet_Publique"
  }
}

resource "aws_security_group" "SidSG" {
  name        = "allow_http_and_SSH"
  description = "Allow HTTP and SSH"
  vpc_id      = "vpc-0f4ab63efa2fc856f"
  ingress {
    description      = "Give access to HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Give access to SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "SidaliSG"
  }
}

resource "aws_instance" "SidEC2" {
  ami           = "ami-02d0b04e8c50472ce"
  instance_type = "t3.micro"
  key_name      = "SidAli_Key"
  subnet_id     = "aws_subnet.Sidsub.id"
  vpc_security_group_ids = ["aws_security_group.SidSG.id"]
tags = {
    Name = "Machine_1"
  }
}

resource "aws_route_table" "SidRT" {
  vpc_id = "vpc-0f4ab63efa2fc856f"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0a197804a9c4fd236"
  }
  tags = {
    Name = "SidaliPubRT"
  }
}

resource "aws_route_table_association" "SidSubRTAssociation" {
  subnet_id      = "aws_subnet.Sidsub.id"
  route_table_id = "aws_route_table.SidRT.id"
}

