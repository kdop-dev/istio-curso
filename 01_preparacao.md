# Instalando docker-engine e docker-desktop

Ref: [Docker Desktop overview](https://docs.docker.com/desktop/)

Você precisará de um cluster de kubernetes para realizar os labs, a forma mais simples é utilizar o kubernetes que acompanha o docker-desktop, porém, se estiver acompanhando este curso em Linux, não há ainda um docker-desktop e algumas opções são listadas abaixo.

Desenvolvemos os exemplos para utilizarem a menor quantidade possível de CPU e memória, porém será necessário um computador com pelo menos 8GB de RAM livre para instalar e executar todos os exemplos.

Se você tem acesso a um nuvem e pode criar um cluster de kubernetes, esta é uma excelente opção, porém normalmente estará associada a algum custo, então tome cuidado.

> Você pode criar um cluster na Google Cloud sem custo, siga as instruções em [README-gke](./README-gke.md)

## Linux e WSL2

* [Guia de instalação do Subsistema Windows para Linux para Windows 10](https://docs.microsoft.com/pt-br/windows/wsl/install-win10)
* [Instalar e configurar o terminal do Windows](https://docs.microsoft.com/pt-br/windows/terminal/get-started)
* [Visual Studio Code](https://code.visualstudio.com/)
* [Introdução ao uso de Visual Studio Code com o subsistema do Windows para Linux](https://docs.microsoft.com/pt-br/windows/wsl/tutorials/wsl-vscode)

### kind

Ref: [Install Docker Engine](https://docs.docker.com/engine/install/) e [kind](https://kind.sigs.k8s.io/)

Siga as instruções para criar um cluster de kubernetes com kind e ajuste o contexto para o cluster criado.

Exemplo:

```bash
# Verificando se kubectl está instalado
kubectl version

# Se não: Instalando kubectl.
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Instalar kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Definindo o cluster - https://kind.sigs.k8s.io/docs/user/configuration/
cat > kind-config.yaml << "EOF"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: istio-curso
nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF

# Crie o cluster, isso pode demorar alguns minutos
kind create cluster --config kind-config.yaml

# Verifique o cluster
kubectl cluster-info --context curso-istio

# Ajuste o contexto para não precisar mais adicionar o parâmetro contexto
kubectl config set-context curso-istio

# Teste novamente
kubectl cluster-info

# Verifique que todos os pods estejam no estado Running antes de prosseguir
# PODs Pending ou Invicted podem indicar que você precisará prover mais recursos (memória / cpu) para o Docker
# Execute: kubectl get pods --field-selector=status.phase=Pending --all-namespaces 
# https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle
kubectl get pods -n kube-system
```

## GKE

Para usar um cluster na Google Cloud ver: [README-gke.md](./README-gke.md)

## Mac

Você precisará aumentar os recursos de CPU e memória disponíveis para o docker, ajuste-os em configurações e, dependendo o seu hardware, habilite o máximo uso de CPU e pelo menos 8GB de memória.

Ref: [Install Docker Desktop on Mac](https://docs.docker.com/docker-for-mac/install/)

## Windows

Se você estiver utilizando o docker-desktop com WSL2 não é necessário aumentar os recursos, porém, se estiver utilizando com máquina virtual, nas configurações incremente a CPU para o máximo e memória para pelo menos 8GB. 

Ref: [Install Docker Desktop on Windows](https://docs.docker.com/docker-for-windows/install/)

## Testando o acesso

Dependendo da opção que você escolheu, provavelmente não precisará definir a variável `KUBECONFIG`.

No docker-desktop e no kind o arquivo fica localizado em `~/.kube/config` e você não precisa configurar a variável KUBECONFIG, em outras situações, você provavelmente baixou o arquivo config, obteve utilizando um cliente de nuvem (az, aws, gcloud, etc), ou ainda recebeu de um administrador, neste caso, siga as instruções para acessar o cluster e configure a variável para o arquivo de config.

```bash
# aponte para onde está o arquivo de config
export KUBECONFIG=$PWD/config
```

Teste o acesso ao cluster com os comandos:

```bash
echo $KUBECONFIG

kubectl cluster-info

kubectl get nodes
```

## Outras alternativas

Você pode optar por não usar o kubernetes que acompanha o docker-desktop ou o kind.

A seguir algumas opções com baixo consumo de recursos da sua máquina.

* [rke](https://rancher.com/products/rke/)
* [minikube](https://minikube.sigs.k8s.io/docs/start/)
* [microk8s](https://microk8s.io/)

Caso você tenha acesso a alguma nuvem, poderá utilizar um cluster de kuberentes como o GKE, AKS ou EKS, mas fique ciente que eles terão custo. Uma outra alternativa é utilizar a infraestrutura do [Katacoda](https://www.katacoda.com/), você pode acessar a versão deste curso nesta plataforma em [Istio avançado para iniciantes](https://www.katacoda.com/adsantos/courses/istio/kubernetes-istio-curso) é uma introdução ao kuberentes e você terá um cluster de kuberentes operacional por algumas horas. Em breve teremos uma versão deste curso também para esta plataforma.

## Ferramentas

Algumas ferramentas ajudarão a melhorar nossa produtividade e outras são essenciais para o curso. 

Recomendamos que você as instale.

* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - A ferramenta de linha de comando do kubernetes. Necessário para executar comandos para o cluster.
* [istioctl](https://istio.io/latest/docs/ops/diagnostic-tools/istioctl/) - CLI para o Istio, será instalado na seção 02.
* [wercker/stern](https://github.com/wercker/stern) - Stern permite acessar log em multiplos PODs e containers.
* curl - CLI para transferir dados via URLs. Procure no google como instala-lo em seu sistema operacional.
* watch - é uma ferramenta de linha de comando, que executa o comando especificado repetidamente. Procure no google para instala-la.
* [hey](https://github.com/rakyll/hey) - Gera carga para aplicações web.
* [httpie](https://httpie.io/) - utilitário para enviar requiisções http com um retorno mais amigável.

## Obtendo o código

Vamos baixar o código que usaremos no curso:

```bash
# Código-fonte
git clone https://github.com/kdop-dev/istio-curso-files.git assets
```

Para iniciar o curso você precisa:

* Acesso a uma infra para o cluster, pode ser um notebook com pelo menos 16GB de RAM ou uma conta ou assinatura de uma nuvem (Para criar na Google Cloud, acesse [README-gke](./README-gke.md));
* Uma notebook, desktop ou máquina virtual para executar o curso;
* linux (ou wsl2);
* docker-desktop (win ou mac);
* docker e kubernetes (para linux ou um cluster na nuvem);
* [miniconda](https://docs.conda.io/en/latest/miniconda.html) para python 3.x, recomendado para gerenciar ambientes de python;
* python 3.x para executar o curso. Requerido, verifique se seu sistema já tem uma versão instalada. Ele também pode ser instalado com miniconda ou seguindo as instruções da página do [python](https://www.python.org/downloads/);
* [jwkgen](https://github.com/rakutentech/jwkgen) para gerar certificados.

### Criando um ambiente para execução

```bash
git clone https://github.com/kdop-dev/istio-curso.git # Ou faça um fork e clone o seu repositório

cd istio-curso

# Instale miniconda ou apenas python 3
# [Requerido] Necessário python versão 3.x
python -V

# [Opcional] Se instalou miniconda
conda create -n istio-curso python=3

conda activate istio-curso

# [Requerido] Instalar as dependências
conda install --file requirements.txt
# Alternativa sem miniconda 
# pip install -r requirements.txt

# [Requerido] Habilitar o kernel de bash para jupyter
python -m bash_kernel.install

# [Opcional] Localize o arquivo de configuração do cluster e altere o valor da variável KUBECONFIG
# Não necessário se já foi configurado por outro método (Ex: Atualizada a configuração pelo cli do clusters de nuvem, minikube ou doker-desktop). Ver PARTE 1 - Preparação. 
# KUBECONFIG=~/.kube/config jupyter lab
jupyter lab
```

### Jupyter lab markdown preview (Opcional)

Por padrão o jupyter lab ira abrir os arquivos _markdown_ no modo de edição, mas você pode selecionar abri-lo no modo _preview_ clicando com o botão direito sobre o nome do arquivo.

Para este curso, vamos sugerir que você altere essa configuração padrão do jupyter lab.

Abra o jupyter lab (`jupyter lab`), se já não estiver aberto, selecione no menu superior _Settings_ | _Advanced Settings Editor_, no menu esquerdo selecione _Document Manager_ e na área _User Preferences_ inclua o seguinte código:

```json
{
    defaultViewers: {
        markdown: "Markdown Preview"
    }
}
```

Selecione o ícone salvar :floppy_disk: no canto superior direito da área.

Com essa configuração, dá próxima vez que você selecionar um arquivo _md_, ele será aberto no modo _preview_ :clap:.

## generic-services

O curso utiliza a imagem pronta do generic-services - [assets/exemplos/generic-services/py](assets/exemplos/generic-services) e não é necessário nenhum passo adicional para utilizá-la, porém, se você desejar modificá-la e criar sua própria imagem, o código-fonte, bem como instruções para construção e entrega, estão em [assets/exemplos/generic-services/py/README.md](exemplos/generic-service/py/README.md)

## Conclusão

Agora estamos prontos para começar, o restante do curso será realizado no jupyter lab (PART 2).
