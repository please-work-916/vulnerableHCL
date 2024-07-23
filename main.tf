terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }


  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  monitoring    = false

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_security_group" "my-group" {
    name        = "allow_tls"
    description = "Allow TLS inbound traffic"
    ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 3389
      to_port          = 3389
      protocol         = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }]
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    viewer_certificate {
      cloudfront_default_certificate = true
      minimum_protocol_version       = "TLSv1"
}

resource "aws_security_group" "my-group-ssh" {
    name        = "allow_tls"
    description = "Allow TLS inbound traffic"
    ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }]
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = "${data.aws_security_group.my-group.id}"
  network_interface_id = "${aws_instance.app_server.primary_network_interface_id}"
}

resource "aws_lb" "test" {
    name                        = "test-lb-tf"
    load_balancer_type          = "application"
    subnets                     = aws_subnet.public.*.id
    drop_invalid_header_fields  = false
}
