resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              echo "Hello from Module!" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server"
  }
} 