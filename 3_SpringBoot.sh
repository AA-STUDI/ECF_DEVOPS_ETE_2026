#!/usr/bin/env bash

cd AT2_SpringBoot
chmod +x local_test.sh
./local_test.sh
if [ $? -ne 0 ]; then echo "ECHEC DU TEST LOCAL, DEPLOIEMENT ANNULE" ; cd .. ; exit 1 ; fi
chmod +x deploy.sh
./deploy.sh
cd ..
