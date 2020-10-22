# Istio avançado para iniciantes (The Advanced Istio for Beginners)

Para obter os artefatos necessários para o curso, clone esse repositório:

```bash
git clone https://github.com/kdop-dev/istio-curso.git
```

Para iniciar o curso você precisa:

* linux (ou wsl2)
* docker-desktop (win ou mac)
* kubernetes (para linux, win e mac usam do docker-desktop)
* python3
* conda

## Criando um ambiente para execução

```bash
cd istio-curso

conda create -n istio-curso python=3

conda activate istio-curso

conda install --file requirements.txt

jupyter lab
```
