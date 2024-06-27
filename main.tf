resource "aws_instance" "demo_instance" {
  ami = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"
}