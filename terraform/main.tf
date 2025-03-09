terraform {
  required_providers{
    aws={
        source = "hashicorp/aws"
    }
  }
}

provider "aws"{
    #configuration options
    region = "us-east-1"
    shared_config_files = [ "$HOME/.aws/config" ]
    shared_credentials_files = [ "$HOME/.aws/credentials" ]
}

