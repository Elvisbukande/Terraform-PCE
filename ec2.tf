resource "aws_instance" "Ben" {
  ami           = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"
  tags          = { Name = "PCE-terraform" }

}