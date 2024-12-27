#!/bin/bash
# Check for root privileges
if [[ ! $(id -u) -eq 0 ]]; then
    echo "Please run this script as sudo."
    exit 1
fi


# Stop all running containers
echo "Stopping all running containers..."
docker stop $(docker ps -q)

# Remove all containers
echo "Removing all containers..."
docker rm $(docker ps -a -q)

# Remove all images
echo "Removing all Docker images..."
docker rmi $(docker images -q)

# Remove all volumes
echo "Removing all Docker volumes..."
docker volume rm $(docker volume ls -q)

# Remove all networks except the default ones (bridge, host, none)
echo "Removing all Docker networks except default ones..."
docker network rm $(docker network ls | grep -v "bridge\|host\|none" | awk '{ print $1 }')

# Prune the system (remove stopped containers, unused images, and unused volumes)
echo "Pruning all unused Docker objects (containers, images, volumes)..."
docker system prune -a --volumes -f

# Remove all Docker data from /var/lib/docker (optional but resets Docker completely)
echo "Removing all Docker data from /var/lib/docker (reset Docker completely)..."
sudo rm -rf /var/lib/docker

# Restart Docker service to apply changes
echo "Restarting Docker service..."
sudo systemctl restart docker

echo "Docker has been reset to a fresh state!"

