# ---------------------------------------------------------
# Bastion Security Group
# ---------------------------------------------------------

resource "aws_security_group" "bastion_sg" {
  name        = "grafana-bastion-sg"
  description = "Allow SSH access to Grafana bastion"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # Replace with your public IP
    cidr_blocks = ["103.5.134.163/32"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "grafana-bastion-sg"
    Environment = "lab"
    Terraform   = "true"
  }
}


# ---------------------------------------------------------
# Bastion EC2
# ---------------------------------------------------------

resource "aws_instance" "grafana_bastion" {

  ami           = var.AMI_ID
  instance_type = "t3.micro"

  # PUBLIC subnet
  subnet_id = module.vpc.public_subnets[0]

  # Assign public IPv4 address
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  # Existing AWS EC2 key pair
  key_name = "rg"

  tags = {
    Name        = "grafana-bastion"
    Environment = "lab"
    Terraform   = "true"
    Purpose     = "Grafana access"
  }
}