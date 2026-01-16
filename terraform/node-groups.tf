resource "aws_eks_node_group" "cloudshop_nodes" {
  cluster_name    = aws_eks_cluster.cloudshop.name
  node_group_name = "cloudshop-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [aws_subnet.cloudshop-subnet-1.id,
                     aws_subnet.cloudshop-subnet-2.id 
                    ]
  instance_types = ["t3.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  #on s'assure que les politiques soient bien attachées au rôle avant de créer les nodes
  depends_on = [
    aws_iam_role_policy_attachment.eks_nodes_cni,
    aws_iam_role_policy_attachment.eks_nodes_worker,
    aws_iam_role_policy_attachment.eks_nodes_ecr,
  ]

}