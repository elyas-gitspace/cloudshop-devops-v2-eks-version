#doc utilisée: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
#fichier de création des repositories ECR qui accueilleront les images docker
#ECR c'est comme un docker hub mais propre à AWS


#utilité de ECR dans notre cas:
#Ton PC / GitHub Actions
#        |
#        |  (docker push)
#        v
#      ECR
#        |
#        |  (docker pull)
#        v
#   EKS (Kubernetes)




resource "aws_ecr_repository" "frontend" {
  name                 = "cloudshop-frontend"
  image_tag_mutability = "MUTABLE" #ce param décrit si l'on a le droit de pousser plusieurs images avec le même tag ou non (par exemple le tag 'latest'), voir doc


  image_scanning_configuration {
    scan_on_push = true #AWS va scanner l'image pour détecter s'il y a des vulnérabilités, risque, failles au système... ou non
  }
}


resource "aws_ecr_repository" "product-api" {
  name                 = "cloudshop-product-api"
  image_tag_mutability = "MUTABLE"


  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_repository" "order-api" {
  name                 = "cloudshop-order-api"
  image_tag_mutability = "MUTABLE"


  image_scanning_configuration {
    scan_on_push = true
  }
}
