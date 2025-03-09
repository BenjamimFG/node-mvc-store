resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "aqui-express-key"
  public_key = tls_private_key.rsa_key.public_key_openssh

  provisioner "local-exec" { # Salva a chave privada localmente
    command = "echo '${tls_private_key.rsa_key.private_key_openssh}' > ../aqui-express-key.pem"
  }
}