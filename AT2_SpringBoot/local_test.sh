#!/bin/bash

IMAGE="infoline-hello-world:1.0.0"
EXPECTED="Hello World !"
PORT=8081
TIMEOUT=30

echo "Build en cours..."
docker build -t $IMAGE . > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors du build" ; exit 1 ; fi

echo "Lancement du container..."
docker run -d --name test-app -p ${PORT}:8080 $IMAGE > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors du montage du container" ; exit 1 ; fi

# Attente du container et envoi de la requête
echo "Test de connexion..."
ready=false
for i in $(seq 1 $TIMEOUT); do
    response=$(curl -s http://localhost:${PORT}/ 2>/dev/null | xargs)
    if [ -n "$response" ]; then
        ready=true
        break
    fi
    sleep 1
done

echo "Arret du container..."
docker stop test-app > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors de l'arrêt du container" ; exit 1 ; fi
echo "Suppression du container..."
docker rm test-app > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors de la suppression du container" ; exit 1 ; fi

# Résultat final
if [ "$ready" = false ]; then
    echo "Erreur lors de la connexion au container"
    exit 1
else
    echo "Reponse attendue : '$EXPECTED'"
    echo "Reponse obtenue : '$response'"
    if [ "$response" = "$EXPECTED" ]; then
        echo "...SUCCES !"
    else
        echo "...ECHEC !"
        exit 1
    fi
fi
