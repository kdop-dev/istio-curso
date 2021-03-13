# GKE Clusters

Uma alternativa para acompanhar este curso é cria um cluster de kubernetes (GKE) na Google Cloud (GCP).

Se essa é a primeira vez que você acessa a GCP você terá um bonús de trezentos dolares para gastar em noventa dias, mais do que suficiente para realizar esse curso, porém, mesmo que você já tenha uma conta na GCP, o GKE tem um [uso gratuíto](https://cloud.google.com/free/docs/gcp-free-tier#always-free-usage-limits) de USD 74,40 por mês por conta de faturamento.

Configuraremos o nosso cluster para ficar dentro da faixa de uso livre, mas recomendamos que você acompanhe, no painle de faturamento, os custos de perto para evitar surpresas.

Você precisará de uma conta Google Cloud (GCP), para obtê-la acesse a <https://cloud.google.com/> e segua com a opção gratuita. 

Você também precisará do cli da GCP, o `gcloud`, para instalá-lo, siga as instruções em <https://cloud.google.com/sdk/docs/install>.

> Se preferir utilize o __cloud shell__ no console do GCP.

Caso já tenha uma conta e o cli instalado, abra um terminal (ou cloudshell) e conecte na sua conta / projeto.

```bash
# Autenticar na GCP (não necessário para cloudshell)
gcloud auth login

# Lista os projetos que você tem acesso
gcloud projects list --format="value(projectId)"

# Define um projeto onde o cluster será criado, caso necessário crie um projeto (use o painel da GCP)
gcloud config set project kdop-dev

# EXECUTE APENAS UMA VEZ
# Criar um cluster com 8 vCPU and 16MB memory
# https://istio.io/latest/docs/setup/platform-setup/gke/
# Estimated cost: 
# Free tier: $74,40
# https://cloud.google.com/free/docs/gcp-free-tier#always-free-usage-limits
# https://cloud.google.com/kubernetes-engine/pricing#cluster_management_fee_and_free_tier
export PROJECT_ID=`gcloud config get-value project`
export M_TYPE=e2-medium
export ZONE=us-central1-c
export CLUSTER_NAME=cluster-1
export MAX_NODES=4
export MIN_NODES=0
export NODE_POLL=default-pool

# Habilitar APIs do GKE 
gcloud services enable container.googleapis.com

# Criar o cluster
gcloud container clusters create $CLUSTER_NAME \
--cluster-version latest \
--machine-type=$M_TYPE \
--num-nodes $MAX_NODES \
--zone $ZONE \
--project $PROJECT_ID

# Obter credenciais do seu cluster
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

# Instalando kubectl
sudo apt-get install kubectl

# Teste
kubectl get nodes
```

## Manutenção do cluster

Você pode reduzir custos parando o cluster quando não estiver usando e iniciando novamente quando for utilizá-lo. As operações de escalar para baixo e para cima controlam quantos nós (máquinas virtuais no caso do cluster padrão) serão iniciados e, por consequência, cobrados.

> Essas operações podem demorar alguns minutos e eventualmente terminar por tempo esgotado (timeout), mas o processo continuará, verifique no painel se o cluster foi escalado corretamente.

```bash
# Reduzir para zero. Reduz custos
# https://cloud.google.com/kubernetes-engine/docs/how-to/managing-clusters#resizing_clusters
gcloud container clusters resize $CLUSTER_NAME --zone $ZONE --node-pool $NODE_POLL \
    --num-nodes $MIN_NODES

# Escalar para quatro nós. Aumenta os custos
gcloud container clusters resize $CLUSTER_NAME --zone $ZONE --node-pool $NODE_POLL \
    --num-nodes $MAX_NODES
```

Mesmo com o cluster escalado para zero nós, o controlador e as configurações continuam lá.

```bash
kubectl cluster-info
# Kubernetes master is running at https://X.X.X.X
# GLBCDefaultBackend is running at https://X.X.X.X/api/v1/namespaces/kube-system/services/default-http-backend:http/proxy
# KubeDNS is running at https://X.X.X.X/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
# Metrics-server is running at https://X.X.X.X/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

kubectl get nodes
# No resources found in default namespace.

kubectl get pods
# NAME                            READY   STATUS    RESTARTS   AGE
# accounts-858bf6bd45-wpzct       0/2     Pending   0          97m
# cart-7f7b54c487-njrwg           0/2     Pending   0          97m
# catalogue-f7775f99b-zhxnl       0/2     Pending   0          97m
# front-end-v1-69f997d4c5-4x47m   0/2     Pending   0          97m
# login-7dc85878d4-x9hcj          0/2     Pending   0          97m
# orders-6d9dbb77f6-dq57n         0/2     Pending   0          97m
# payment-64b6447b79-v4s4z        0/2     Pending   0          97m
# shipping-8d4fc666c-q27s8        0/2     Pending   0          97m
```
