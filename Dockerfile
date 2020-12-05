#FROM jupyter/minimal-notebook:latest
FROM jupyter/base-notebook:latest

USER root

RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y apt-transport-https gnupg2 curl wget

# Docker
RUN apt install docker.io -y
RUN usermod -aG docker jovyan

# kind
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
RUN mv ./kind /usr/local/bin/kind && chmod +x /usr/local/bin/kind

# kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

RUN mv ./kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

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

