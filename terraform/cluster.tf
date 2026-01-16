#doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
#dans ce fichier nous allons créer le cluster EKS, voir le google doc pour voir son utilité

resource "aws_eks_cluster" "cloudshop" {
  name = "cloudshop-cluster-eks"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.eks_cluster.arn #le nom du rôle que l'on a crée dans iam.tf | rôle pour que EKS puisse créer et gérer des ressources
  version  = "1.31"

  vpc_config {
    subnet_ids = [
      aws_subnet.cloudshop-subnet-1.id,
      aws_subnet.cloudshop-subnet-2.id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy, #nom de la politique que l'on a attaché au rôle pour EKS. "depends on" sert à s'assurer que la politique ait bien été attachée au rôle avant d'effectuer quelconques actions 
  ]
}