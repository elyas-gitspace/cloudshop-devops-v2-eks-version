#VPC = une grande zone réseau privée
#et un subnet = une sous-zone à l’intérieur
#donc la on crée un

resource "aws_subnet" "cloudshop-subnet-1" {
  vpc_id     = aws_vpc.cloudshop_vpc.id
  cidr_block = "10.0.3.0/24" #plage d'adresses ip (voir vpc.tf)
  availability_zone  = "eu-west-1a"
  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "cloudshop-subnet-2" {
  vpc_id            = aws_vpc.cloudshop_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone  = "eu-west-1b" #on choisit une autre zone de dispo dans la même région pour la haute disponibilité
  tags = {
    Name = "cloudshop-subnet-1"
  }
}
