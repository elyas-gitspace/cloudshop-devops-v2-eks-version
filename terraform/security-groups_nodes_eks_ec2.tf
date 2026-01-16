#après avoir rédigé dans security-groups_elb.tf un sg entre internet et ELB (ne laissant passer que les requêts hhtp et https (80 et 443)
#on va rédiger ce security-groups_nodes_eks_ec2.tf qui autorise le trafic venant de ELB ainsi que la communication interne entre node)

#security-groups_nodes_eks_ec2.tf qui sera attaché à notre cluster EKS

#Internet
#   |
#   v (sg public ici)
#[ AWS Load Balancer ]
#   |
#   v (sg nodes EKS ici) -- NOUS L'ATTACHERONS ICI
#[ Cluster EKS (Kubernetes) ]

resource "aws_security_group" "cloudshop_eks" {
  name        = "cloudshop-eks-sg"
  description = "sg-cloudshop_eks"
  vpc_id      = aws_vpc.cloudshop_vpc.id
  tags = {
    Name = "sg-cloudshop_eks"
  }
}

#                                                                     Règles ingress
#maintenant on ajoute des règles au sein de ce groupe de sécurité
#Ensuite, pour attribuer cet ensemble de règles (donc le groupe de sécurité les contenant), à une ressource,
#on utilisera 'aws_security_group.cloudshop_eks.id' au moment de la création de la ressource en question (nodes eks = ec2)

resource "aws_vpc_security_group_ingress_rule" "allow_traffic_from_lb" {
  depends_on = [aws_security_group.cloudshop] #on s'assure que le sg elb soit crée avant (vu qu'on y fait référence ici 3 lignes plus loins)
  security_group_id            = aws_security_group.cloudshop_eks.id #on lie cette règle au groupe de sécurité actuel
  referenced_security_group_id = aws_security_group.cloudshop.id #on autorise le trafic venant du groupe de sécurité du Load Balancer (ELB)
  from_port   = 5000 # 3000 to 32767 c'est la plage de ports NodePort Kubernetes
  to_port     = 5000 #ici c'est comme si on disait '“J’autorise le trafic TCP provenant du Load Balancer vers les nodes EKS uniquement sur les ports NodePort Kubernetes”'
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_nodes_internal" {
  security_group_id            = aws_security_group.cloudshop_eks.id
  referenced_security_group_id = aws_security_group.cloudshop_eks.id

  ip_protocol = "-1"
} #on autorise tout trafic réseau provenant des ressources (en loccurence nodes eks ec2) qui utilisent le sg aws_security_group.cloudshop_eks. Voir détails sur mon google doc

#                                                                       Règles egress

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.cloudshop_eks.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}