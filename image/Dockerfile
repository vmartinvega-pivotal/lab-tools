#FROM python:3.11.1 AS production
FROM mcr.microsoft.com/vscode/devcontainers/anaconda AS production

ARG HOST_USER_UID=2000
ARG HOST_USER_GID=2000

RUN groupadd --gid "${HOST_USER_GID}" daf && \
    useradd --create-home --shell /bin/bash --uid "${HOST_USER_UID}" --gid "${HOST_USER_GID}" daf && echo "daf:changeme" | chpasswd && \
    usermod -aG sudo daf

RUN curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && \
    chmod 755 /usr/local/bin/kubectl
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc && \
    chmod 755 /usr/local/bin/mc

ARG JUJU_VERSION=2.9.45
RUN curl -LO https://launchpad.net/juju/2.9/${JUJU_VERSION}/+download/juju-${JUJU_VERSION}-linux-amd64.tar.xz \
    && mkdir juju \
    && tar xf juju-${JUJU_VERSION}-linux-amd64.tar.xz -C juju \
    && cd juju && install -o root -g root -m 0755 juju /usr/local/bin/juju \
    && rm -Rf juju \
    rm juju-${JUJU_VERSION}-linux-amd64.tar.xz

RUN apt-get update && \
    apt-get install -y \
        sshpass \
        expect \
        cifs-utils \
        wget && \
    apt-get clean

COPY requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt
RUN ansible-galaxy collection install \
    kubernetes.core \
    community.vmware \
    vmware.vmware_rest \
    community.windows \
    community.docker \
    ansible.posix \
    -p /usr/share/ansible/collections
ENV ANSIBLE_PYTHON_INTERPRETER=/opt/conda/bin/python
ENV ANSIBLE_USER=daf
ENV ANSIBLE_FORCE_COLOR=True

# Install ovftool
COPY VMware-ovftool-4.4.1-16812187-lin.x86_64.bundle ovftool.bundle
RUN chmod +x ovftool.bundle \
    && ./ovftool.bundle --extract ovftool \
    && mv ovftool/vmware-ovftool /usr/bin/ \
    && chmod +x /usr/bin/vmware-ovftool/ovftool.bin \
    && chmod +x /usr/bin/vmware-ovftool/ovftool

# Install powershell
RUN wget -q "https://github.com/PowerShell/PowerShell/releases/download/v7.3.6/powershell_7.3.6-1.deb_amd64.deb"
RUN dpkg -i powershell_7.3.6-1.deb_amd64.deb
RUN rm powershell_7.3.6-1.deb_amd64.deb
RUN pwsh -Command Install-Module -Name PSScriptAnalyzer -Scope AllUsers -Force && \
    pwsh -Command Install-Module -Name VMware.PowerCLI -Scope AllUsers -Force && \
    pwsh -Command Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore -Scope AllUsers -Confirm:'$false' && \
    pwsh -Command Set-PowerCLIConfiguration -ParticipateInCEIP:'$false' -Scope AllUsers -Confirm:'$false' && \
    mkdir -p /.local && \
    chgrp -R 0 /.local && \
    chmod -R g=u /.local

USER daf

RUN helm plugin install https://github.com/databus23/helm-diff

# Configure image for development
FROM production as development

ARG HOST_DOCKER_GID=999

USER root

# Install dev tools
RUN apt-get update && \
    apt-get install -y \
        shellcheck \
        vim \
        iputils-ping \
        ca-certificates \
        curl \
        gnupg \
        lsb-release && \
    apt-get clean

# Install docker cli
RUN addgroup docker --gid "${HOST_DOCKER_GID}" && \
    adduser daf docker && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean

USER daf

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Shell definition required to create mc completion
ARG SHELL=bash
RUN sed -i '/^completions=(/a \ \ docker' "${HOME}/.bashrc" && \
    sed -i '/^completions=(/a \ \ docker-compose' "${HOME}/.bashrc" && \
    kubectl completion bash > "${HOME}/.oh-my-bash/custom/completions/kubectl.completion.sh" && \
    sed -i '/^completions=(/a \ \ kubectl' "${HOME}/.bashrc" && \
    helm completion bash > "${HOME}/.oh-my-bash/custom/completions/helm.completion.sh" && \
    sed -i '/^completions=(/a \ \ helm' "${HOME}/.bashrc" && \
    mc --autocompletion
