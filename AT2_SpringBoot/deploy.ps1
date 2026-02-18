$IMAGE_NAME = "infoline-hello-world"
$IMAGE_VERSION = "1.0.0"
$AWS_REGION = "eu-west-3"
$ECR_REPO_NAME = "infoline-hello-world"
$CLUSTER_NAME = "infoline-eks-cluster"

Write-Host "Deploiement en cours..."

# Build
docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} . | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors du build" ; exit 1 }

# Verification/Creation du repository ECR selon son existence
aws ecr describe-repositories --repository-names $ECR_REPO_NAME --region $AWS_REGION | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Repository ECR non existant, creation en cours..."
    aws ecr create-repository --repository-name $ECR_REPO_NAME --region $AWS_REGION | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la creation ECR" ; exit 1 }
}

# Recuperation ID du compte AWS
$AWS_ACCOUNT_ID = (aws sts get-caller-identity --query Account --output text)

# Creation de l'URL ECR
$ECR_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Connexion ECR : (mode insecurisé pour éviter le pipe PowerShell qui corrompt le token)
$ECR_PASSWORD = (aws ecr get-login-password --region $AWS_REGION).Trim()
docker login --username AWS --password $ECR_PASSWORD $ECR_URL | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la connexion ECR" ; exit 1 }

# Creation/tag du nom de l'image ECR
$ECR_IMAGE = "${ECR_URL}/${ECR_REPO_NAME}:${IMAGE_VERSION}"
docker tag ${IMAGE_NAME}:${IMAGE_VERSION} $ECR_IMAGE
# Push de l'image vers ECR
docker push $ECR_IMAGE | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors du push ECR" ; exit 1 }

# Mise a jour du kubeconfig
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la configuration kubectl" ; exit 1 }

# Recuperation du contenu du fichier deployment.yaml
$deploymentContent = Get-Content k8s/deployment.yaml -Raw
# Modification de l'image afin de pointer vers le repository ECR
$updatedContent = $deploymentContent -replace "image: infoline-hello-world:1.0.0", "image: $ECR_IMAGE"
# Creation du fichier deployment-temp.yaml avec le contenu modifié
$updatedContent | Set-Content k8s/deployment-temp.yaml
# Deploiement des ressources Kubernetes
kubectl apply -f k8s/deployment-temp.yaml | Out-Null
kubectl apply -f k8s/service.yaml | Out-Null
# Suppression du fichier temporaire
Remove-Item k8s/deployment-temp.yaml
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors du deploiement K8S" ; exit 1 }

Write-Host "...SUCCES !"
