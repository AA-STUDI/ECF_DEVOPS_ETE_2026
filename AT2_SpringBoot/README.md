# Activité Type 2 : application 'Hello World' Spring Boot

## Prérequis

- JDK 25 (compilation locale du .jar via le Maven Wrapper `mvnw`.)
- Docker : https://www.docker.com/
- Compte AWS configuré localement.
- Kubernetes CLI
- Cluster Kubernetes (voir https://github.com/AA-STUDI/AT1_Infrastructure pour le déploiement de l'infrastructure.)
- Note : l'image Docker est construite localement pour l'architecture de la machine, et les nœuds EKS (`t3.large`) sont en x86-64. Les scripts actuels supposent que la machine locale est également en x86-64, mais sur une machine ARM (ex. Mac Apple Silicon), il est indispensable d'ajouter `--platform linux/amd64` à la commande `docker build` des scripts.

## Scripts automatisés

### Powershell

`.\local_test.ps1` : test local de l'image Docker (avant déploiement.)

`.\deploy.ps1` : déploiement de l'application sur le cluster Kubernetes.

### Bash

`./local_test.sh` : test local de l'image Docker (avant déploiement.)

`./deploy.sh` : déploiement de l'application sur le cluster Kubernetes.

## Supprimer l'application du cluster Kubernetes

`kubectl delete -f k8s/`