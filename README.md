[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/kdop-dev/istio-curso)

# Istio avançado para iniciantes (The Advanced Istio for Beginners)

## Conteúdo

A curva de aprendizado do Istio é relativamente íngreme - por isso projetamos este curso para ser o mais claro e compreensível possível e espero que com as demonstrações práticas você também se divirta ao longo do caminho

- Na [PARTE 1](./01_preparacao.ipynb) instalaremos as ferramentas necessárias na sua máquina windows, mac e linux, tais como:
  - kubectl - linha de comando para interagir com o kubernetes
  - istioctl - utilitário de linha de comando para instalar e configurar a instalação do istio e acessar seus dashboards e configurações.
  - stern - ferrameta para acessar logs dos containers
  - http e curl - para enviarmos requisições http para nossos serviços
- Instalaremos um cluster de kubernetes econfiguraremos acesso das ferramentas a ele
- E iremos configurar sua máquina para acessar a parte interativa do curso.
- Na [PARTE 2](./02_execucao_istio.ipynb) vamos instalar o Istio no nosso cluster e fazer o _deploy_ da nossa primeira aplicação
- Na [PARTE 3](./03_visualizacao_kiali.ipynb) iremos instalar e acessar o dashboard do Kiali, uma das melhores ferramentas integradas com o Istio
- Na [PARTE 4](./04_instalando_simul_shop.ipynb) você iremos apresentá-lo a nossa aplicação simul-shop.
- Inspirado no micro-sock, desenvolvida pela weaveworks, ela foi desenvolvida em python e empacotada como uma imagem docker, é configurável para emular microsserviços e, no nosso curso, foi configurada para simular uma loja virtual.
- Na [PARTE 5](./05_multi_container_pods.ipynb) discutiremos sobre peça fundamental do Istio, o Envoy.
- Faremos uma configuração básica do Envoy e discutiremos porque o Istio adiciona o Envoy automaticamente nas suas aplicações
- Na [PARTE 6](./06_arquitetura_do_istio.ipynb) apresentaremos a arquitetura do Istio, o que é uma malha de serviços, como ela funciona e porque ele é tão importante no desenvolvimento de arquiteturas orientadas a serviço.
- Na [PARTE 7](./07_telemetria.ipynb) apresentaremos as ferramentas de telemetria do Istio, veremos mais sobre o Kiali, o qual veremos com mais detalhes, também o Jaeger para rastreamento distribuído de logs e como ajustar sua aplicação para um melhor resultado e o grafana com os dashboards de métricas pré-configurados com a instalação do Istio.
- Na [PARTE 8](./08_gerenciamento_trafego_visao_geral.ipynb) Iremos fazer nosso primeiro desenvolvimento para o Istio, configuraremos o roteamento de tráfego para uma entrega canário, uma dos blocos fundamentais do Istio e que permite criar cenários complexos de forma simples.
- Na [PARTE 9](./09_load_balancing.ipynb) iremos configurar o balanceamento de carga que tem como objetivo distribuir a carga de forma uniforme aplicando diferentes algoritmos. O Istio tem um grande conjunto de recursos para balanceamento de carga que vão muito além dos oferecidos pelo kubernetes.
- Na [PARTE 10](./10_gateways.ipynb) apresentaremos os gateways, aplicações independentes (Envoys) que controlam o tráfego das requisições que entream e saem da malha de serviços. Eles recebem as requisições, avaliam, criam logs e redirecionam para os serviços dentro e fora da malha.
- Na [PARTE 11](./11_gerenciamento_trafego_avancado.ipynb) retomamos a configuração para gerenciamento de tráfego com cenários mais complexo como:
  - rotas baseadas na URI
  - rotas baseadas nas variávels do cabeçalho da requisição http
  - Combinação de multiplas regras de roteamento
  - Configurações de resiliência para retentativas, tratamento de _timeouts_ e proteção de serviços com _circuit brackers_
  - E configurações para auxiliar nos testes como o espelhamento de tráfego
- A [PARTE 12](./12_seguranca.ipynb) foi dividida em duas, na primeira apresentaremos como o Istio trás a segurança com parte integral da solução, como customizá-la e controla-la. Veremos como negar e autorizar acesso aos nossos serviços e bloquear todo o tráfego não autorizado para fora da nossa malha de serviços.
- Na [segunda parte](./12a_seguranca.ipynb), veremos como utilizar JWT tokens na autorização de acessos (RBAC) para os serviços
- Na [PARTE 13](./13_engenharia_caos.ipynb) vamos explorar os recursos do Istio para a engenharia do caos, simularemos falhas nos serviços para avaliar como nossa malha se comporta.
- Na [PARTE 14](./14_istio_vms.ipynb) trataremos de como utilizar o Istio fora do cluster de kubernetes, trazendo máquinas virtuais para a malha de serviços. Esse é um tema que tem atraído bastante a atenção da comunidade, para atender a necessidade de cargas de trabalho que não se encaixam bem em containers, mas se beneficiarião das funcionalidades e integração com a malha de serviços, criando malhas híbridas compostas de máquinas virtuais e PODs.
- As [PARTE 15](./15_referencias.md) e [16](./16_contribuicoes.md) são respectivamente as referências, recomendações e materiais para aprofundamento no tema e como contribuir com esse curso. Você poderá enviar pedidos de novos exemplos ou submeter os seus para que façam parte desse curso. Manteremos ele atualizado e crescendo em conteúdo para mantê-lo afiado.

Há três versões deste curso:

* [Github - asantos2000/katacoda-scenarios](https://github.com/asantos2000/katacoda-scenarios)
* [Katacoda - Get Started with Istio and Kubernetes - Estimado: 25/01/2021](https://www.katacoda.com/adsantos/courses/istio/deploy-istio-on-kubernetes)
* [Udemy - Istio avançado para iniciantes - Anderson/ Daniel e Leonardo - Estimado 01/03/2021]()

## Curso no Github

Para obter os artefatos necessários para o curso, clone esse repositório:

```bash
git clone https://github.com/kdop-dev/istio-curso.git
```

Para iniciar o curso você precisa:

* Acesso a uma infra para o cluster, pode ser um notebook com pelo menos 16GB de RAM ou uma conta ou assinatura de uma nuvem.
* Uma notebook, desktop ou máquina virtual para executar o curso
* linux (ou wsl2)
* docker-desktop (win ou mac)
* docker e kubernetes (para linux ou um cluster na nuvem)
* python3 para executar o curso
* conda para gerenciar ambientes de python
* [jwkgen](https://github.com/rakutentech/jwkgen) para gerar certificados.

### Criando um ambiente para execução

```bash
git clone https://github.com/kdop-dev/istio-curso.git # Ou faça um fork e clone o seu repositório

cd istio-curso

python -V
# Python 3.x

conda create -n istio-curso python=3

conda activate istio-curso

conda install --file requirements.txt

python -m bash_kernel.install

# [Opcional] Localize o arquivo de configuração do cluster e altere o valor da variável KUBECONFIG
# Não necessário para docker-desktop
# jupyter lab
KUBECONFIG=~/.kube/config jupyter lab
```

#### Jupyter lab markdown preview (Opcional)

Por padrão o jupyter lab ira abrir os arquivos _markdown_ no modo de edição, mas você pode selecionar abri-lo no modo _preview_ clicando com o botão direito sobre o nome do arquivo.

Para este curso, vamos sugerir que você altere essa configuração padrão do jupyter lab.

Abra o jupyter lab (`jupyter lab`), se já não estiver aberto, selecione no menu superior _Settings_ &#8594; _Advanced Settings Editor_ e na área _User Preferences_ inclua o seguinte código:

```json
{
    defaultViewers: {
        markdown: "Markdown Preview"
    }
}
```

Selecione o ícone salvar :floppy_disk: no canto superior direito da área.

Com essa configuração, dá próxima vez que você selecionar um arquivo _md_, ele será aberto no modo _preview_ :clap:.

### generic-services

O curso utiliza a imagem pronta do generic-services - [exemplos/generic-services/py](exemplos/generic-services) e não é necessário nenhum passo adicional para utilizá-la, porém, se você desejar modificá-la e criar sua própria imagem, o código-fonte, bem como instruções para construção e entrega, estão em [exemplos/generic-services/py/README.md](exemplos/generic-service/py/README.md)

## Nossos planos

- [X] Versão para download [github](https://github.com/kdop-dev/istio-curso) - Dez/2020
- [ ] [Katacoda](https://www.katacoda.com/) - Previsão: Jan/2020
- [ ] [mybinder](https://mybinder.org/) - Previsão: Jan/2020
- [ ] [Udemy](https://udemy.com) - Previsão: Mar/2020
