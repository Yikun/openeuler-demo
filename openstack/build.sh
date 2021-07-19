#!/bin/bash

# Download openEuler-20.03-LTS-SP2
if [ ! -f "openEuler-docker.aarch64.tar.xz" ]; then
  wget https://repo.openeuler.org/openEuler-20.03-LTS-SP2/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
fi

# Load docker image
docker load < openEuler-docker.aarch64.tar.xz

# Build docker image
docker build . -t openeuler-20.03-lts-sp2:init

# Run init
docker run --name openstack -tid --privileged=true -p 8000:80 -h controller openeuler-20.03-lts-sp2:init

# Exec openstack setup script
docker exec -ti openstack /opt/run.sh

# Test for horizon
STATUSCODE=$(curl -m 10 -o /dev/null -s -w %{http_code} http://127.0.0.1:8000/dashboard/auth/login/)
if test $STATUSCODE -ne 200; then
  echo "Horizon auth page: Failed with "$STATUSCODE"."
else
  echo "Horizon auth page: OK, 200."
fi