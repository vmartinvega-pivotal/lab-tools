DOCKER_ACCOUNT=vmartinvega
docker build --platform linux/amd64 -t $DOCKER_ACCOUNT/streamlit:latest .
docker login --username $DOCKER_ACCOUNT
docker push $DOCKER_ACCOUNT/streamlit:latest

kubectl create secret generic openai-info \
    --from-file=password=./openai_password.txt