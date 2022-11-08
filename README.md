## Versão Atual

- **v1.2.3**

## Status do Projeto

- **EM DESENVOLVIMENTO**

## Sobre

- Projeto de um compilador implementado em java com JFlex e JavaCUP.

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
    - docker build -t compilador:v1.2.3 .

## Execução
- Java Local
  - java -jar .\target\compiler-v1.2.3-shaded.jar
- Docker 
    - docker run -i compilador:v1.2.3

## Comandos

- compile [-l | --lexical-analysis [fileName] [-o resultFileName]] [-g | --generate-analyzer [fileName]]
- cat [fileName]
- clear

# Atenção 
### Necessário adicionar o arquivo de teste.
- Formato do arquivo de teste
  - .txt 
- Formato do arquivo de lexema
  - .flex
- Formato do arquivo de gramatica
  - .cup
### Resultado da análise é gerado em:
  - src/main/java/br/compiler/result/*.txt
 