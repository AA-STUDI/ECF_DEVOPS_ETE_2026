$elasticUser = kubectl get secret elasticsearch-cluster-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
Write-Host "Kibana accessible a l'adresse: https://localhost:5601"
Write-Host "Utilisateur/Mot de passe : elastic/$elasticUser"
Write-Host "CTRL+C pour quitter"
kubectl port-forward service/kibana-kb-http 5601:5601 | Out-Null