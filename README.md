### **☁️ CloudShop — Projet DevOps Kubernetes (AWS · Terraform · EKS · CI/CD)**

__Présentation générale__

```
CloudShop est une application cloud-native en microservices, déployée sur AWS avec Kubernetes (EKS) et entièrement provisionnée via Terraform.

Ce projet illustre un workflow DevOps professionnel et réaliste :

- Aucune création manuelle d’infrastructure

- Infrastructure décrite en code (IaC)

- Déploiement automatisé via CI/CD

- Architecture sécurisée (du moins suffisante dans le cadre de notre projet scolaire) et scalable
```

__Objectifs du projet__

```
Créer toute l’infrastructure AWS avec Terraform

Déployer une application microservices sur Amazon EKS

Utiliser Amazon ECR comme registre Docker

Mettre en place une CI/CD avec GitHub Actions
```

__Architecture__

```
Application -->

- Frontend (interface web)

- Product API

- Order API

Infrastructure -->

- VPC AWS (réseau isolé)

- Subnets publics et privés (multi-AZ)

- Amazon EKS (Kubernetes managé)

- Node Groups EC2 (autoscaling)

- Application Load Balancer

- Amazon ECR (images Docker)

- IAM Roles (aucune clé AWS dans le code)
```

__Structure du dépôt__


```
cloudshop/
├── terraform/
│   ├── providers.tf
│   ├── variables.tf
│   ├── network/
│   │   ├── vpc.tf
│   │   ├── subnets.tf
│   │   └── security-groups.tf
│   ├── ecr/
│   │   └── repositories.tf
│   └── eks/
│       ├── cluster.tf
│       ├── node-groups.tf
│       └── iam.tf
│
├── k8s/
│   ├── frontend/
│   ├── product-api/
│   ├── order-api/
│   └── ingress.yaml
│
├── frontend/
├── product-api/
├── order-api/
│
└── .github/
    └── workflows/
        └── ci-cd.yml
```

### **__Workflow global__**

__Provisionnement de l’infrastructure (Terraform)__

```
- Le réseau (VPC, subnets, security groups)

- Les repositories ECR (pour stocker les images)

- Le cluster EKS

- Les node groups EC2

- Les rôles IAM nécessaires
```

__CI/CD avec GitHub Actions__

```
À chaque git push :

Build des images Docker

Push des images vers Amazon ECR

Authentification au cluster EKS

Déploiement/mise à jour via Kubernetes
```

__Exécution de l’application__

```
- L’utilisateur accède à l’application via une URL publique

- Le Load Balancer AWS reçoit le trafic

Kubernetes gère :

le placement des pods

la haute disponibilité

le redémarrage automatique

le scaling
```

__Principes de sécurité__


```
- Aucune clé AWS dans les conteneurs

Permissions via rôles IAM :

- Rôle du cluster EKS

- Rôle des nodes EC2

- Permissions CI/CD

- Subnets privés pour les pods

- Contrôle du trafic via Security Groups
```

### **Fichier deploy.yml dans cloudshop-devops/.github/workflows/**

```
name: Deploy CloudShop to EKS

on:
  push:
    branches: [ main ]
    paths-ignore:
      - 'README.md'  # Ignore les modifications du README.md

jobs:
  deploy:
    name: Build, Push, and Deploy
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-west-1

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build, tag, and push frontend image
        run: |
          docker build -t 375033339237.dkr.ecr.eu-west-1.amazonaws.com/cloudshop-frontend:latest ./frontend
          docker push 375033339237.dkr.ecr.eu-west-1.amazonaws.com/cloudshop-frontend:latest

      - name: Build, tag, and push product-api image
        run: |
          docker build -t 375033339237.dkr.ecr.eu-west-1.amazonaws.com/cloudshop-product-api:latest ./product-api
          docker push 375033339237.dkr.ecr.eu-west-1.amazonaws.com/cloudshop-product-api:latest

      - name: Build, tag, and push order-api image
        run: |
          docker build -t 375033339237.dkr.ecr.eu-west-1.amazonaws.com/cloudshop-order-api:latest ./order-api
          docker push 375033339237.dkr.ecr.eu-west-1.amazonaws.com/cloudshop-order-api:latest

      - name: Update kubeconfig for EKS
        run: |
          aws eks update-kubeconfig --name cloudshop-cluster-eks --region eu-west-1

      - name: Deploy to EKS
        run: |
          kubectl apply -f k8s/
```