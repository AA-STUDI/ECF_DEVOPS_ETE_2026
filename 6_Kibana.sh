#!/usr/bin/env bash

elasticUser=$(kubectl get secret elasticsearch-cluster-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
echo "Kibana accessible à l'adresse: https://localhost:5601"
echo "Utilisateur/Mot de passe : elastic/$elasticUser"
echo "CTRL+C pour quitter"
kubectl port-forward service/kibana-kb-http 5601:5601
