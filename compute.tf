resource "aws_instance" "web" {
    #AMI ID NGINX = ami-07af7fe16709ae05e
    #AMI ID UBUNTU = ami-0822295a729d2a28e
  ami                         = "ami-07af7fe16709ae05e"
  associate_public_ip_address = true
  instance_type               = "t3.micro"

  tags = merge(local.common_tags, {
    Name = "06-resources-sg"
  })

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_http_traffic.id]
}

resource "aws_security_group" "public_http_traffic" {
  description = "Security group allowing traffic on ports 443 and 80"
  name        = "public-http-traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

}