#!/bin/bash

IMAGE_NAME="infoline-hello-world"
IMAGE_VERSION="1.0.0"
AWS_REGION="eu-west-3"
ECR_REPO_NAME="infoline-hello-world"
CLUSTER_NAME="infoline-eks-cluster"

echo "Deploiement en cours..."

# Build
docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} . > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors du build" ; exit 1 ; fi

# Verification/Creation du repository ECR selon son existence
aws ecr describe-repositories --repository-names $ECR_REPO_NAME --region $AWS_REGION > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Repository ECR non existant, creation en cours..."
    aws ecr create-repository --repository-name $ECR_REPO_NAME --region $AWS_REGION > /dev/null 2>&1
    if [ $? -ne 0 ]; then echo "Erreur lors de la creation ECR" ; exit 1 ; fi
fi

# Recuperation ID du compte AWS
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Creation de l'URL ECR
ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Connexion ECR (password/token récupérée via AWS CLI)
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors de la connexion ECR" ; exit 1 ; fi

# Creation/tag du nom de l'image ECR
ECR_IMAGE="${ECR_URL}/${ECR_REPO_NAME}:${IMAGE_VERSION}"
docker tag ${IMAGE_NAME}:${IMAGE_VERSION} $ECR_IMAGE
# Push de l'image vers ECR
docker push $ECR_IMAGE > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors du push ECR" ; exit 1 ; fi

# Mise a jour du kubeconfig
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors de la configuration kubectl" ; exit 1 ; fi

# Recuperation du contenu du fichier deployment.yaml
deploymentContent=$(cat k8s/deployment.yaml)
# Modification de l'image afin de pointer vers le repository ECR
updatedContent=$(echo "$deploymentContent" | sed "s|image: infoline-hello-world:1.0.0|image: $ECR_IMAGE|")
# Creation du fichier deployment-temp.yaml avec le contenu modifié
echo "$updatedContent" > k8s/deployment-temp.yaml
# Deploiement des ressources Kubernetes
kubectl apply -f k8s/deployment-temp.yaml > /dev/null 2>&1
kubectl apply -f k8s/service.yaml > /dev/null 2>&1
# Suppression du fichier temporaire
rm k8s/deployment-temp.yaml
if [ $? -ne 0 ]; then echo "Erreur lors du deploiement K8S" ; exit 1 ; fi

echo "...SUCCES !"
