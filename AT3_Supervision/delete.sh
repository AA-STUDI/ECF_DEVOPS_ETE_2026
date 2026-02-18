#!/usr/bin/env bash

echo "Suppression en cours..."

kubectl delete -f filebeat-kubernetes.yaml
if [ $? -ne 0 ]; then echo "Erreur lors de la suppression Filebeat" ; fi
kubectl delete -f kibana.yaml
if [ $? -ne 0 ]; then echo "Erreur lors de la suppression Kibana" ; fi
kubectl delete -f elasticsearch.yaml
if [ $? -ne 0 ]; then echo "Erreur lors de la suppression Elasticsearch" ; fi
kubectl delete -f storage-class.yaml
if [ $? -ne 0 ]; then echo "Erreur lors de la suppression Storage Class" ; fi
kubectl delete -f https://download.elastic.co/downloads/eck/3.3.0/operator.yaml
if [ $? -ne 0 ]; then echo "Erreur lors de la suppression Operator ECK" ; fi
kubectl delete -f https://download.elastic.co/downloads/eck/3.3.0/crds.yaml
if [ $? -ne 0 ]; then echo "Erreur lors de la suppression CRDs" ; fi

echo "...TERMINE !"
