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


resource "aws_lb" "test" {
    name                        = "test-lb-tf"
    load_balancer_type          = "application"
    subnets                     = aws_subnet.public.*.id
    drop_invalid_header_fields  = false
}
