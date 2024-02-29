DOCKER_ACCOUNT=vmartinvega
APPLICATION=summary-images

docker build --platform linux/amd64 -t $DOCKER_ACCOUNT/$APPLICATION:latest .
docker login --username $DOCKER_ACCOUNT
docker push $DOCKER_ACCOUNT/$APPLICATION:latest
