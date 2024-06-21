# resource "aws_security_group" "PCE_SG" {
#   name        = "PCE_SG"
#   description = "Allow TLS inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.Ben.id

#   tags = {
#     Name = "PCE_SG"
#   }
# }
# ingress {
#   security_group_id = aws_security_group.PCE_SG.id
#   cidr_ipv4         = aws_vpc.Ben.cidr_block
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

# ingress {
#   security_group_id = aws_security_group.PCE_SG.id
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
#   security_group_id = aws_security_group.PCE_SG.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }





# Define a security group to allow HTTP and SSH access
resource "aws_security_group" "pce-terraform-sg" {
  name_prefix = "pce-terraform-sg"
  vpc_id      = aws_vpc.Ben.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
