#doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
#ici on indique à terraform sur quel cloud il va travailler, et dans quelle région (AWS et eu-west-1 dans notre cas)

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"

  assume_role {
    role_arn = "arn:aws:iam::375033339237:role/cloudshop-role"  #ARN de notre rôle que terraform va utiliser de force (car on lui demande)
  }
}
