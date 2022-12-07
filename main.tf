provider "aws" {
    region = "us-east-1"
}

##### vpc block ######

resource "aws_vpc" "myVPC" {
  cidr_block = "10.0.0.0/16"
}

############ internet gateway #####

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "igw"
  }
}


############ subnet ###############

resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet"
  }
}

################# route table ###########


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myVPC.id

   route = []

  /* route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = null
  } */

  tags = {
    Name = "example"
  }
}


############## route #########


resource "aws_route" "r" {
  route_table_id            = aws_route_table.rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id  =  aws_internet_gateway.igw.id
  depends_on                = [aws_route_table.rt]
}


#################### secutiy group ##########

resource "aws_security_group" "sg" {
  name        = "allow_all traffice"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0      ### for all ports
    to_port          = 0      ### for all ports 
    protocol         = "-1"    ### For all traffic 
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks =  null
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "all traffic"
  }
}


########### route table  association ###########


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.rt.id
}


################# EC2 Instance ################

resource "aws_instance" "ec2" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t2.micro"
   subnet_id = aws_subnet.mysubnet.id
  tags = {
    Name = "prabhatdwivedi"
  }
}
