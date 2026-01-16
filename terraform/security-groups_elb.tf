#doc utilisée: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule


#ici on crée le groupe de sécurité (à ce stade, il est vide et ne contient aucune règle, par défaut, il n'accepte donc aucun trafic réseau)
#il faut donc y ajouter par la suite des rules ingress (entrantes) et egress (sortantes)


#security_group_1_public qui sera attaché à notre Load Balancer


resource "aws_security_group" "cloudshop" {
  name        = "cloudshop-sg"
  description = "sg-cloudshop"
  vpc_id      = aws_vpc.cloudshop_vpc.id
  tags = {
    Name = "sg-cloudshop"
  }
}




#                                                                     Règles ingress
#maintenant on ajoute des règles au sein de ce groupe de sécurité
#Ensuite, pour attribuer cet ensemble de règles (donc le groupe de sécurité les contenant), à une ressource,
#on utilisera 'aws_security_group.cloudshop.id' au moment de la création de la ressource en question


resource "aws_vpc_security_group_ingress_rule" "allow_443" {
  security_group_id = aws_security_group.cloudshop.id #on saisit l'id du groupe de sécurité juste au dessus
  cidr_ipv4         = "0.0.0.0/0" #cidr_ipv4 est le paramètres désignant d'où l'on accepte le trafic. En loccurence, nous acceptons toutes les ip d'internet (tant qu'elles sont ipv4)
                                  #il existe aussi cidr_ipv6 mais les adresses ipv6 ne représentent que 5% d'internet donc pas indispensable pour notre projet
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443   #ici les paramètres from --> to désignent la plage de ports que l'on autorise. Ici, c'est comme si on disait 'j'autorise le trafic arrivant du port 443
                            # jusqu'au port 443'. Donc en gros on accepte que 443 = https
}




# idem que la règle du dessus mais pour le port 80
resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.cloudshop.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


# Ainsi, le Load Balancer accepte UNIQUEMENT des requêtes Internet qui arrivent sur :
#        - HTTP (80)
#        - HTTPS (443)”


#                                                                     Règles egress


#règle de sortie: ici on réponds à la question 'vers qui cette ressource à le droit d'envoyer du trafic'
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.cloudshop.id
  cidr_ipv4         = "0.0.0.0/0" #la ressource (en l'occurence load balancer) a le droit d'envoyer du trafic vers toutes les ips sur internet
  ip_protocol       = "-1" # equivalent de 'tous les protocoles' = la ressource peut communiquer via tous les protocoles (et pas que tcp)
}


#voila sous forme de shcéma ce qu'on vient de faire dans ce fichier (security-groups_elb.tf): 
#   Internet
#     |
#     |  (80 / 443 autorisés)
#     v 
#[ Load Balancer ]
#     |
#     |  (egress libre)
#     v
# [ Nodes EKS ]


#Internet
#   |
#   v (sg public ici)
#[ AWS Load Balancer ]
#   |
#   v (sg nodes EKS ici)
#[ Cluster EKS (Kubernetes) ]


#Cluster EKS
#│
#├── Node 1 (EC2)
#│     ├── Pod Frontend
#│     │      └── Conteneur frontend
#│     │
#│     └── Pod Product API
#│            └── Conteneur product-api
#│
#├── Node 2 (EC2)
#│     └── Pod Order API
#│            └── Conteneur order-api


#c'est kubernetes (EKS) qui décide de la répartition des pod dans chaque node (machine EC2)