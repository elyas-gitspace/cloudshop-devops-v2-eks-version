output "eks_cluster_endpoint" {
  value = aws_eks_cluster.cloudshop.endpoint
}

output "ecr_repository_urls" {
  value = {
    frontend    = aws_ecr_repository.frontend.repository_url
    product_api = aws_ecr_repository.product-api.repository_url
    order_api   = aws_ecr_repository.order-api.repository_url
  }
}
