resource "aws_instance" "web" {
  ami           = "ami-0a346c29399cd4934" #devops-practice
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.roboshop-all.id]
  tags = {
    Name = "provisioner"
  }

  provisioner "local-exec" {
    command = "echo this will execute at the time of creation, you can trigger other system like email and sending alerts" # self = aws_instance.web
  }  

    provisioner "local-exec" {
    command = "echo ${self.private_ip} > inventory" # self = aws_instance.web
  }

  # provisioner "local-exec" {
  #   command = "ansible-playbook -i inventory web.yaml" # self = aws_instance.web
  # }

    provisioner "local-exec" {
    command = "echo this will execute at the time of destroy, you can trigger other system like email and sending alerts" # self = aws_instance.web
    when = destroy
  } 

  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "echo 'this ids from remote ecec' > /temp/remote.txt",
      "sudo yum install nginx -y",
      "sudo systemctl start nginx"
    ]
  }
}

resource "aws_security_group" "roboshop-all" {
    name        = "provisioner"

    ingress {
        description      = "Allow All ports"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "provisioner"
    }
}


