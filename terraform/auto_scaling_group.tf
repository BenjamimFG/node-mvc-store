resource "aws_iam_role" "iam_role" {
  name = "aqui-express-iam-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name                  = "aqui-express-iam-role"
  role = aws_iam_role.iam_role.name
  path                  = "/"


  tags = {
    project = "aqui-express"
  }
  tags_all = {
    project = "aqui-express"
  }
}

resource "aws_launch_template" "launch_template" {
  name                                 = "aqui-express-lt"
  image_id                             = "ami-04b4f1a9cf54c11d0"
  instance_type                        = "t2.micro"
  key_name                             = aws_key_pair.key_pair.key_name

  iam_instance_profile {
    arn  = aws_iam_instance_profile.iam_instance_profile.arn
  }

  metadata_options {
    http_endpoint               = "enabled"
  }

  network_interfaces {
    associate_public_ip_address  = "true"
    security_groups             = [aws_security_group.rds_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update
    apt install -y nodejs npm
    npm i -g pm2

    cd ~

    git clone https://github.com/BenjamimFG/node-mvc-store.git

    cd node-mvc-store

    npm i

    rm -rf .env

    echo "PORT=80" >> .env
    echo "DB_URL='mysql://admin:${aws_secretsmanager_secret_version.password.secret_string}@${aws_db_instance.rds_db.endpoint}/AQUI_EXPRESS'" >> .env

    pm2 start server.js
    EOF
  )

  tags = {
    project = "aqui-express"
  }

  tags_all = {
    project = "aqui-express"
  }
}

resource "aws_autoscaling_group" "web_asg" {
  min_size           = 2
  max_size           = 5
  desired_capacity   = 2
  
  availability_zones               = ["us-east-1a"]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}
