#doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster

#CLUSTER
# Rôle IAM pour le cluster EKS (ex: créer des Security Groups, Load Balancers)
#jusque ici, le rôle est vide et ne sert à rien, car on ne lui a toujours pas attaché de politiques (= de droits)
resource "aws_iam_role" "eks_cluster" {
  name = "cloudshop-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"  # Seuls les services EKS peuvent utiliser ce rôle
      }
    }]
  })
}

# on attache la politique AmazonEKSClusterPolicy au rôle
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  # Politique gérée par AWS
}

#NODES
# Rôle IAM pour les nœuds EC2 (ex: tirer des images depuis ECR)
resource "aws_iam_role" "eks_nodes" {
  name = "cloudshop-eks-nodes-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"  # Seuls les nœuds EC2 peuvent utiliser ce rôle
      }
    }]
  })
}

# AmazonEKSWorkerNodePolicy
# elle permet aux nœuds de rejoindre le cluster EKS et d'interagir avec AWS (ex: tags, métriques CloudWatch)
resource "aws_iam_role_policy_attachment" "eks_nodes_worker" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# AmazonEC2ContainerRegistryReadOnly
# elle permet aux nœuds de tirer (pull) les images Docker depuis ECR (notre "Docker Hub privé AWS")
resource "aws_iam_role_policy_attachment" "eks_nodes_ecr" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# AmazonEKS_CNI_Policy
# elle permet aux pods de communiquer entre eux via le réseau AWS
# si on a pas ça, nos pods n'auront PAS d'IP et ne pourront PAS communiquer
resource "aws_iam_role_policy_attachment" "eks_nodes_cni" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

#PODS
# le rôle IAM pour les pods Kubernetes (ex: accéder à S3, RDS)
# Rôle IAM pour les pods Kubernetes (ex: futur accès à S3/RDS si besoin)
resource "aws_iam_role" "eks_pods" {
  name = "cloudshop-eks-pods-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${replace(aws_eks_cluster.cloudshop.identity[0].oidc[0].issuer, "https://", "")}"
      }
      Condition = {
        StringEquals = {
          "oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${replace(aws_eks_cluster.cloudshop.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:*:*"
        }
      }
    }
  ]
})

}

