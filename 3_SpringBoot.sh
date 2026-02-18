#!/usr/bin/env bash

cd AT2_SpringBoot
./local_test.sh
if [ $? -ne 0 ]; then echo "ECHEC DU TEST LOCAL, DEPLOIEMENT ANNULE" ; cd .. ; exit 1 ; fi
./deploy.sh
cd ..
