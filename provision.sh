
#!/bin/bash
set -e

# Install Docker CE and Compose on a fresh Ubuntu VM
if ! command -v docker >/dev/null 2>&1 || ! docker compose version >/dev/null 2>&1; then
apt-get update
apt-get install -y ca-certificates curl

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
-o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

. /etc/os-release
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi
# Start Docker
systemctl enable --now docker

# Create the shared Docker network if missing
docker network inspect prf-network >/dev/null 2>&1 || \
  docker network create prf-network

# Deploy both applications
cd /vagrant
docker compose up -d --build

# Show running containers
docker compose ps
