resource "aws_security_group" "rds_sg" {
  name        = "aqui-express-rds-sg"
  description = "Permite comunicacao TCP dentro da rede VPC na porta 3306"

  tags = {
    project = "aqui-express"
  }
}

resource "aws_security_group_rule" "name" {
  security_group_id = aws_security_group.rds_sg.id
  type = "ingress"
  from_port = 0
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}