resource "aws_instance" "cerberus" {

  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.cerberus-key.id
  user_data     = <<USERDATA
{
#!/bin/bash
sudo yum update -y
sudo yum install nginx -y
sudo systemctl start nginx
}
USERDATA

}

resource "aws_eip" "eip" {
  instance = aws_instance.cerberus.id
  vpc      = true
  provisioner "local-exec" {
    command = "echo ${self.public_dns} >> /root/cerberus_public_dns.txt.txt"
  }
}
resource "aws_key_pair" "cerberus-key" {
  key_name   = "cerberus"
  public_key = file("/root/terraform-projects/project-cerberus/.ssh/cerberus.pub")
}
