terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

}

provider "aws" {
  region  = "eu-west-2"
  access_key = "AKIAXBIKMTAJQRRYSGD2"
  secret_key = "JSdX5dv3nVxRN2QzDMgQ1m3ESXa502FTPm+ijogn"

}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet_1" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "netcad" {
  subnet_id   = "${aws_subnet.my_subnet_1.id}"
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "EC2_Instance" {
  ami           = "ami-06bd7f67e90613d1a" # eu-west-2 zone
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = "${aws_network_interface.netcad.id}"
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}