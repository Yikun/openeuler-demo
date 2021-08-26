# Download openEuler-20.03-LTS-SP2
if [ ! -f "openEuler-docker.aarch64.tar.xz" ]; then
  wget https://repo.openeuler.org/openEuler-20.03-LTS-SP2/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
fi

# Load docker image
docker load < openEuler-docker.aarch64.tar.xz

docker build -f Dockerfile -t openlk .
docker rm -f openlk
docker run --name openlk -ti --privileged=true -p 8001:8001 -h openeuler openlk
