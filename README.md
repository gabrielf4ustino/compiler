## Current version

- **v1.2.3**

## Project Status

- **CONCLUDED**

## About

- Project of a compiler implemented in Java with JFlex and JavaCUP.

## Prerequisites

- JDK 18
- Maven 3.8.*

## Installation

- Local Java
  - git clone [url]
  - cd .\compiler\
  - mvn clean install
-Docker
  - git clone [url]
  - cd .\compiler\
  - docker build -t compiler:v1.2.3 .

## Execution
- Local Java
  - java -jar .\target\compiler-v1.2.3-shaded.jar
-Docker
  - docker run -i compiler:v1.2.3

## Commands

- compile --help

# Attention
### Need to add the test file.
- Test file format
  - .txt
- Lexeme file format
  - .flex
- Grammar file format
  - .cup
### Analysis result is generated in:
- ./src/main/java/br/compiler/result/
