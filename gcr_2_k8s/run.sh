#!/bin/bash

# 1

gsutil cp gs://$DEVSHELL_PROJECT_ID/echo-web.tar.gz .
tar zxvf echo-web.tar.gz

docker build -t echo-app .

# 2

gcloud auth configure-docker
docker tag echo-app gcr.io/$DEVSHELL_PROJECT_ID/echo-app:v1
docker push gcr.io/$DEVSHELL_PROJECT_ID/echo-app:v1

# 3

gcloud config set compute/zone us-central1
gcloud container clusters create echo-cluster

# 4

kubectl create deployment -f manifest/echo-web.yaml
kubectl create service -f manifest/echo-ingress.yaml