## Versão Atual

- **v1.2.2**

## Status do Projeto

- **EM DESENVOLVIMENTO**

## Sobre

- Projeto de um compilador implementado em java.

## Pré requisitos

- JDK 18
- Maven 3.8.*

## Instalação

- Java local
    - git clone [url]
    - cd .\compilador\
    - mvn clean install
- Docker
    - git clone [url]
    - cd .\compilador\
    - docker build --rm -t compilador:v1.1.1 .

## Execução
- Java Local
    - mvn exec:java
- Docker 
    - docker run -i compilador:v1.1.1

## Comandos

- compile [-l | --lexical-analysis [fileName] [-o resultFileName]] [-g | --generate-analyzer [fileName]]
- cat [fileName]
