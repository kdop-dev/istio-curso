# Istio avançado para iniciantes (The Advanced Istio for Beginners)

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

## Criando um ambiente para execução

```bash
git clone https://github.com/kdop-dev/istio-curso.git # Ou faça um fork e clone o seu repositório

cd istio-curso

conda create -n istio-curso python=3

conda activate istio-curso

conda install --file requirements.txt

# Localize o arquivo de configuração do cluster e altere o valor da variável KUBECONFIG
env KUBECONFIG=caminho/arquivo jupyter lab
```

## generic-services

O curso utiliza a imagem pronta do generic-services - [exemplos/generic-services/py](exemplos/generic-services) e não é necessário nenhum passo adicional para utilizá-la, porém, se você desejar modificá-la e criar sua própria imagem, o código-fonte, bem como instruções para construção e entrega, estão em [exemplos/generic-services/py/README.md](exemplos/generic-service/py/README.md)

## Nossos planos

- [ ] Versão para download [github](https://github.com/kdop-dev/istio-curso) - Em progresso, Lançamento: Dez/2020
- [ ] Versão do curso no [Katacoda](https://www.katacoda.com/) - Previsão: Jan/2020.
- [ ] Versão do curso no [mybinder](https://mybinder.org/) - Previsão: Jan/2020
- [ ] Versão do curso [Udemy](https://udemy.com) - Previsão: Fev/2020
