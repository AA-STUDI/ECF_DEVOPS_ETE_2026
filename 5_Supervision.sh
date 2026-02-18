#!/usr/bin/env bash

cd AT3_Supervision
./deploy.sh
echo "NOTE : les pods déployés avant les outils de supervision doivent être redémarrés pour être visibles par ceux-ci."
echo "Exemple pour l'application Spring Boot de l'activité type 2 :"
echo "kubectl rollout restart deployment/infoline-hello-world"
cd ..
