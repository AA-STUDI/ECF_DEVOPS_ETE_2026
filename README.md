# Evaluation en Cours de Formation - ECF - TP - Administrateur système DevOps - ETE 26

Chaque activité est disponible dans un sous-dossier :

- "AT 1 : Automatisation du déploiement d’infrastructure dans le Cloud" : `./AT1_Infrastructure`
- "AT 2 : Déploiement d’une application en continu" : `./AT2_SpringBoot` et `./AT2_Angular`
- "AT 3 : Supervision des services déployés" : `./AT3_Supervision`

## Déploiement et tests automatisés

### Prérequis

- Terraform CLI : https://developer.hashicorp.com/terraform/install
- AWS CLI : https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- Kubernetes CLI : https://kubernetes.io/docs/tasks/tools/
- Docker : https://www.docker.com/
- Node.js : https://nodejs.org/en/download
- Compte AWS avec utilisateur IAM (access key)
- Configuration AWS validée via `aws configure` : entrer la paire clé/secret du compte/utilisateur IAM, puis choisir la région (*eu-west-3*), et output format (*json*)

### Scripts d'exécution (disponibles au format Powershell .ps1 ou Bash .sh au choix)

*Note : sur environnement Linux, il est nécessaire de rendre exécutables les scripts avant toute opération :* `chmod +x *.sh`

`1_Terraform` : Déploiement de l'infrastructure sur le compte AWS configuré.

`2_TestLambda` : Test de la fonction Lambda sur l'infrastructure.

*Note : pour le script suivant, sur environnement Linux, il peut être nécessaire d'ajouter les droits docker à l'utilisateur en cours :* `sudo usermod -aG docker $UTILISATEUR_ACTUEL`*. Une reconnexion de l'utilisateur est nécessaire pour appliquer ce changement.*

`3_SpringBoot` : Test local puis déploiement de l'application Spring Boot sur l'infrastructure.

`4_Angular` : Build et test de l'application Angular (local.)

`5_Supervision` : Déploiement des outils de supervision sur l'infrastructure.

`6_Kibana` : Port-forwarding du port 5601 et affichage des identifiants pour utiliser Kibana sur la machine locale.

`7_SuppressionK8s` : Suppression de tous les déploiements sur l'infrastructure.

`8_SupressionInfrastructure` : Suppression de l'infrastructure du compte AWS configuré.
