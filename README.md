## How to create the Ubuntu template
Create VM with operating system
/ and /home with enough space
yum update
install python
dnf install python3
mkdir -p /opt/conda/bin
ln -s /usr/bin/python3 /usr/local/bin/python
ln -s /usr/bin/python3 /opt/conda/bin/python

add users (with sudo) (daf and vicente)
create .ssh folder (chmod 700) copy the authorized_keys id_rsa y id_rsa.pub al directorio
sudo yum install -y perl gcc make kernel-headers kernel-devel

### Unbound
The unbound service is started following this repo 
https://github.com/MatthewVance/unbound-docker/blob/master/README.md

### Working with conda
Create a conda env
```
conda env create --file conda_envs/ai_env.yml
```

Update conda env
```
conda env update -f conda_envs/pytorch212.yml --prune
```

## How-to bootstrap

* Create a file sudo_pass.txt with the sudo password for the linux VMs
* Create a file vault_pass.txt with the password for the vault (same as windows)
* Create a file ansible_win_user_pass.txt with the passord for the windows machine

# How to access Kubeapps and dashboard
```
kubectl -n default create token homelab-admin
```

### Running from outside dev container

* Build the docker image
```
docker build --target development -t lab-tools:latest image/.
```

* Create the following aliases
```
alias bootstrap="docker run -v /home/\"${USER}\"/lab-tools:/home/daf/lab-tools \
--env ANSIBLE_COLLECTIONS_PATHS=/home/daf/lab-tools/collections \
-v /home/\"${USER}\"/.kube:/home/daf/.kube \
-v /home/\"${USER}\"/.ssh:/home/daf/.ssh \
--rm lab-tools:latest /home/daf/lab-tools/scripts/bootstrap.sh\"$@\""
```
```
alias actions="docker run -v /home/\"${USER}\"/lab-tools:/home/daf/lab-tools \
--env ANSIBLE_COLLECTIONS_PATHS=/home/daf/lab-tools/collections \
-v /home/\"${USER}\"/.kube:/home/daf/.kube \
-v /home/\"${USER}\"/.ssh:/home/daf/.ssh \
--rm lab-tools:latest /home/daf/lab-tools/scripts/actions.sh\"$@\""
```

### Running AI
- Deploy the ai jumphost
- Initialize jupyter server 
```bash
jupyter notebook --ip=192.168.1.166
```
Connect from the host to the provided url