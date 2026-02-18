# Activité Type 1 : Infrastructure

## Prérequis

- Terraform CLI : https://developer.hashicorp.com/terraform/install
- AWS CLI : https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- Kubernetes CLI : https://kubernetes.io/docs/tasks/tools/
- Compte AWS avec utilisateur IAM (access key)

## Configuration AWS

`aws configure` : entrer la paire clé/secret du compte/utilisateur IAM, puis choisir la région (*eu-west-3*), et output format (*json*.)

## Déploiement de l'infrastructure

`terraform init` : initialisation de Terraform.

`terraform plan` : planification préliminaire avant déploiement final (facultatif.)

`terraform apply` : déploiement de l'infrastructure sur AWS.

## Fonction *Lambda*

### Tests

Connexion admin : `aws lambda invoke --function-name infoline-login-function --cli-binary-format raw-in-base64-out --payload file://test-admin.json --region eu-west-3 response.json`

Identifiants invalides : `aws lambda invoke --function-name infoline-login-function --cli-binary-format raw-in-base64-out --payload file://test-invalid.json --region eu-west-3 response.json`

Identifiants manquants : `aws lambda invoke --function-name infoline-login-function --cli-binary-format raw-in-base64-out --payload file://test-missing.json --region eu-west-3 response.json`

Connexion utilisateur : `aws lambda invoke --function-name infoline-login-function --cli-binary-format raw-in-base64-out --payload file://test-user.json --region eu-west-3 response.json`

Le résultat est disponible dans le fichier `response.json` après chaque test.

### Logs d'exécution CloudWatch

`aws logs tail /aws/lambda/infoline-login-function --region eu-west-3`

## Destruction de l'infrastructure

`terraform destroy`