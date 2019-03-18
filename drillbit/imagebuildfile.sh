#!/bin/bash

export version=1.0.0

cd ~/repos/masterarbeit/docker-drill-cluster/drillbit
docker build -t mfisser/drillbit:${version} ./
docker push mfisser/drillbit:${version}