#https://srivastavayushmaan1347.medium.com/creating-a-secure-and-scalable-aws-vpc-with-terraform-3270a189b228

resource "aws_vpc" "cloudshop_vpc" { #ressource {type_de_ressource_aws} {nom_local_à_terraform_que_l'on_donne_à_la_ressource}
                                     #en donnant ce nom local à terraform à cette ressource vpc, 
                                     #on pourra l'appeler depuis un autre script via: vpc_id = aws_vpc.cloudshop_vpc.id

  cidr_block = "10.0.0.0/16" # Dans notre réseau virtuel vpc, chaque machine aura une ip. Ainsi, /16 signifie : 2¹⁶ = 65 536 adresses IP possibles dans ce VPC
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "cloudshop-vpc"
  }
}
