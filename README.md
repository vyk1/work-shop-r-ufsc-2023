# Repositório referente ao curso de R ministrado pela Me. [Luciele Leonhardt Romanowski](http://lattes.cnpq.br/9793099276681415) na Universidade Federal de Santa Catarina - Campus Florianópolis.

Este repositório usou [Rocker RStudio](https://github.com/rocker-org/rocker). Você pode baixar a imagem do docker [aqui](https://hub.docker.com/r/rocker/rstudio/).

Há um docker-compose.yml para facilitar a execução do RStudio. Para executar o RStudio, basta executar o comando abaixo:

```bash
docker-compose up
```

Um Dockerfile também está disponível para facilitar a criação de uma imagem com os pacotes necessários para o curso. Para criar a imagem, basta executar o comando abaixo:

```bash
docker build -t rcurso .
```

O RStudio estará disponível em http://localhost:8787. O usuário é `rstudio` e a senha é gerada automaticamente pelo docker-compose. Para descobrir a senha, execute o comando abaixo:

```bash
docker-compose logs rstudio
```