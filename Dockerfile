#FROM jupyter/minimal-notebook:latest
FROM jupyter/base-notebook:latest

USER root

RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y apt-transport-https gnupg2 curl wget

# Docker
RUN apt install docker.io -y
RUN usermod -aG docker jovyan

# Kubernetes
# TODO

# kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

RUN mv kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# helm
RUN wget -c "https://get.helm.sh/helm-v3.3.1-linux-amd64.tar.gz" -O - | tar -xz && mv linux-amd64/helm /usr/local/bin/helm && chmod +x /usr/local/bin/helm && rm -rf linux-amd64

# install the notebook package
RUN pip install --no-cache --upgrade pip

RUN pip3 install ipykernel bash_kernel nbgitpuller && python3 -m bash_kernel.install

# create user with a home directory
ENV HOME /home/${NB_USER}

USER $NB_UID
WORKDIR ${HOME}

#COPY --chown=${NB_USER}:${NB_GID} . ${HOME}
COPY . ${HOME}

USER root
RUN chmod 777 ${HOME}/sh

