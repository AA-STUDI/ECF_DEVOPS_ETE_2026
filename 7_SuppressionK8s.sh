#!/usr/bin/env bash

cd AT3_Supervision
./delete.sh
cd ..
kubectl delete -f ./AT2_SpringBoot/k8s/
