# Activité Type 2 : application 'Hello World' Spring Boot

## Prérequis

- Docker : https://www.docker.com/
- Compte AWS configuré localement.
- Kubernetes CLI
- Cluster Kubernetes (voir https://github.com/AA-STUDI/AT1_Infrastructure pour le déploiement de l'infrastructure.)

## Scripts automatisés

### Powershell

`.\local_test.ps1` : test local de l'image Docker (avant déploiement.)

`.\deploy.ps1` : déploiement de l'application sur le cluster Kubernetes.

### Bash

`./local_test.sh` : test local de l'image Docker (avant déploiement.)

`./deploy.sh` : déploiement de l'application sur le cluster Kubernetes.

## Supprimer l'application du cluster Kubernetes

`kubectl delete -f k8s/`