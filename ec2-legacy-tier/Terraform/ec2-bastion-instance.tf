resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.access_key_name
  subnet_id     = aws_subnet.sandbox_subnet_public_1.id

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public-bastion" }))
}

resource "aws_security_group" "bastion_sg" {
  description = "Control bastion inbound and outbound access"
  name        = "${local.prefix}-bastion"
  vpc_id      = aws_vpc.sandbox_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      aws_subnet.sandbox_subnet_private_1.cidr_block,
      aws_subnet.sandbox_subnet_private_2.cidr_block,
      aws_subnet.sandbox_subnet_public_1.cidr_block,
      aws_subnet.sandbox_subnet_public_2.cidr_block,

    ]
  }

  tags = local.common_tags
}