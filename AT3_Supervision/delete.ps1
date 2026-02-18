Write-Host "Suppression en cours..."

kubectl delete -f filebeat-kubernetes.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la suppression Filebeat" }
kubectl delete -f kibana.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la suppression Kibana" }
kubectl delete -f elasticsearch.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la suppression Elasticsearch" }
kubectl delete -f storage-class.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la suppression Storage Class" }
kubectl delete -f https://download.elastic.co/downloads/eck/3.3.0/operator.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la suppression Operator ECK" }
kubectl delete -f https://download.elastic.co/downloads/eck/3.3.0/crds.yaml | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la suppression CRDs" }

Write-Host "...TERMINE !"