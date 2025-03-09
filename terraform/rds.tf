resource "random_password" "rds_pw" {
  length = 32
  special = false
}

resource "aws_secretsmanager_secret" "password" {
  name = "aqui-express-db-pw"
}

resource "aws_secretsmanager_secret_version" "password" {
  depends_on = [ random_password.rds_pw ]
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.rds_pw.result
}

resource "aws_db_instance" "rds_db" {
  depends_on = [ aws_secretsmanager_secret_version.password ]
  identifier = "aqui-express-rds"
  allocated_storage = 20
  engine = "mysql"
  instance_class = "db.t3.micro"
  db_name = "AQUI_EXPRESS"
  username = "admin"
  password = aws_secretsmanager_secret_version.password.secret_string
  multi_az = false # Desativado devido ao custo
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true

  tags = {
    project = "aqui-express"
  }
}

output "rds_host" {
  value = aws_db_instance.rds_db.endpoint
}

output "rds_password" {
  sensitive = true
  value = random_password.rds_pw.result
}