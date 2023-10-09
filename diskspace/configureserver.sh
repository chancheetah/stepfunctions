#!/bin/bash
sudo yum update -y && sudo yum install python3-pip -y
sudo pip install boto boto3
sudo pip install ansible