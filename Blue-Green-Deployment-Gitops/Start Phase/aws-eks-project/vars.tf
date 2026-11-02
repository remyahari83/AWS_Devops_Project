variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMIS" {
  type = map(any)
  default = {

    us-east-1 = "ami-0f8a61b66d1accaee"
  }
}

variable "PRIV_KEY_PATH" {
  default = "vprofilekey"
}

variable "PUB_KEY_PATH" {
  default = "vprofilekey.pub"
}

variable "USERNAME" {
  default = "ubuntu"
}

variable "MYIP" {
  default = "122.161.240.2/32"
}


variable "instance_count" {
  default = "1"
}

variable "VPC_NAME" {
  default = "vprofile-VPC"
}

variable "Zone1" {
  default = "us-east-1a"
}

variable "Zone2" {
  default = "us-east-1b"
}

variable "Zone3" {
  default = "us-east-1c"
}

variable "VpcCIDR" {
  default = "172.21.0.0/16"
}




variable "PubSub1CIDR" {
  default = "172.21.1.0/24"
}

variable "PubSub2CIDR" {
  default = "172.21.2.0/24"
}

variable "PubSub3CIDR" {
  default = "172.21.3.0/24"
}

variable "PrivSub1CIDR" {
  default = "172.21.4.0/24"
}

variable "PrivSub2CIDR" {
  default = "172.21.5.0/24"
}

variable "PrivSub3CIDR" {
  default = "172.21.6.0/24"
}

variable "AMI_ID" {
  description = "The AMI ID for the EC2 instance."
  default     = "ami-0522ab6e1ddcc7055"  # Replace with your desired AMI ID
}

variable "my_ip" {
  description = "Your IP address for SSH access."
  default     = "0.0.0.0/0"  # Replace with your actual IP or CIDR block
}


