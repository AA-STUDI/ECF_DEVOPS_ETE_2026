#!/bin/bash

echo "Installation des dependances..."
npm install > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors de l'installation" ; exit 1 ; fi

echo "Build de l'application..."
npm run build > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "Erreur lors du build" ; exit 1 ; fi

echo "Execution des tests..."
npm run test > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "... ECHEC !" ; exit 1 ; fi

echo "... SUCCES !"
