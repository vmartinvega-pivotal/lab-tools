# Remove all images
docker rmi $(docker images -a -q)

# Remove all containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# system prune
docker system prune
