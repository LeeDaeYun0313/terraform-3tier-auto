resource "aws_security_group" "ldy_websg" {
  name        = "Allow-WEB"
  description = "http-ssh-icmp"
  vpc_id      = aws_vpc.ldy_vpc.id

  ingress = [
    {
      description      = var.prot_ssh
      from_port        = var.ssh_port
      to_port          = var.ssh_port
      protocol         = var.prot_tcp
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = var.prot_http
      from_port        = var.http_port
      to_port          = var.http_port
      protocol         = var.prot_tcp
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = var.prot_icmp
      from_port        = var.under_port
      to_port          = var.under_port
      protocol         = var.prot_icmp
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    },
    {
      description     = "tomcat"
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = var.prot_sql
      from_port        = var.mysql_port
      to_port          = var.mysql_port
      protocol         = var.prot_tcp
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "ALL"
      from_port        = var.zero_port
      to_port          = var.zero_port
      protocol         = "-1"
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    }
  ]

  tags = {
    Name = "${var.name}-sg"
  }
}

##########################

#data "aws_ami" "amzn" {
#  most_recent = true
#
#  filter {
#    name   = "name"
#    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#  }
#
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#
#  owners = ["amazon"]
#
#}


resource "aws_instance" "ldy_web" {

  ami                    = var.ami
  instance_type          = var.instance
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.ldy_websg.id]
  availability_zone      = "${var.region}${var.avazone[0]}"
  private_ip             = var.private_ip
  subnet_id              = aws_subnet.ldy_pub[0].id
  user_data              = file("./../01_module/install_seoul.sh")

  tags = {
    Name = "${var.name}-weba"
  }
}

resource "aws_eip" "ldy_web_eip" {
 
  vpc                       = true
  instance                  = aws_instance.ldy_web.id
  associate_with_private_ip = var.private_ip
  depends_on                = [aws_internet_gateway.ldy_igw]

}


####was


resource "aws_instance" "ldy_wasa" {
    ami                         = var.ami
    instance_type               = var.instance
    key_name                    = var.key
    vpc_security_group_ids      = [aws_security_group.ldy_websg.id]
    availability_zone           = "ap-northeast-2a"
    private_ip                  = "10.0.0.12"
    subnet_id                   = aws_subnet.ldy_pub[0].id
    user_data                   = file("./../01_module/install_was.sh")

    tags = {
      Name = "ldy-wasa"
    }
}

resource "aws_eip" "ldy_was_eip" {
  vpc = true
  instance = aws_instance.ldy_wasa.id
  associate_with_private_ip = "10.0.0.12"
  depends_on = [aws_internet_gateway.ldy_igw]
  
}

