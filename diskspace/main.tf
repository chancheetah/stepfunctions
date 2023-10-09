terraform {
  required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "~> 4.16"
    }
  }
  required_version = ">=1.2.0"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_role" "cct_ssm_ec2_role" {
  name = "cct_ssm_ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cct_ssm_s3policy" {
  role       = aws_iam_role.cct_ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "cct_ssm_ec2_profile" {
  name = "cct_ssm_ec2_profile"
  role = aws_iam_role.cct_ssm_ec2_role.name
}

resource "aws_instance" "example_server" {
    ami             = "ami-03a6eaae9938c858c"
    instance_type   = "t2.micro"
    count           = "2"
    subnet_id       = "subnet-0a3af629cf353f4da"
    iam_instance_profile = aws_iam_instance_profile.cct_ssm_ec2_profile.name

    tags = {
        Name = "testssm"
        Consumer = "chancheetah"
        Environment = "POC"
        DataClassification = "Proprietary"
        Service = "BlueSky"
    }
}
