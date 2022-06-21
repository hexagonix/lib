# Português

## Bibliotecas para o desenvolvimento de aplicativos e utilitários

Este repositório contém bibliotecas e macros importantes para o desenvolvimento de utilitários para o Hexagonix e Andromeda.

### Aviso de direitos autorais

Veja a [Licença](LICENSE) para mais informações.

### Bibliotecas Andromeda

As bibliotecas exclusivas para apps Andromeda estão dentro do diretório Estelar, e contam com as seguintes bibliotecas, até o momento:

* Estelar (biblioteca padrão para renderização e manipulação gráfica)
* Big Bang (biblioteca padrão para manipular dispositivos de som e emitir notas)

### Bibliotecas Hexagon

As bibliotecas Hexagon compreendem vários componentes que permitem ao aplicativo interagir com o Hexagon, outros aplicativos e com dispositivos padrão. Até o momento, as bibliotecas Hexagon são:

* hexagon (biblioteca que permite ao aplicativo realizar chamadas de sistema ao Hexagon, usando a API exposta)
* dispositivos (fornece nomes e dados de dispositivos utilizados em chamadas de sistema)
* erros (funções e códigos para manipulação de erros)
* HAPP (funções para criação de cabeçalhos HAPP sob demanda e manipulação de imagens HAPP)
* log (macros e dados para enviar mensagens pelo sistema de mensagens do Hexagon)
* macros (macros úteis para uso global ao realizar chamadas de sistema em assembly, como abrir();)
* sistema (funções e dados para gerenciamento de versão hardcoded em aplicativos)
* verUtils (funções para processar arquivos no formato OCL e obter dados de versão e atualização de forma dinâmica)

# English

## Libraries for developing applications and utilities

This repository contains libraries and macros for developing utilities for Hexagonix and Andromeda.

### Copyright notice

See [License](LICENSE) for more information.

### Andromeda Libraries

The exclusive libraries for Andromeda apps are inside the Estelar directory, and they have the following libraries, so far:

* Estelar (default library for rendering and graphics manipulation)
* Big Bang (standard library for manipulating sound devices and issuing notes)

### Hexagon Libraries

The Hexagon libraries comprise several components that allow the application to interact with Hexagon, other applications, and standard devices. So far, the Hexagon libraries are:

* hexagon (library that allows the application to make system calls to Hexagon, using the exposed API)
* dispositivos (provides device names and data used in system calls)
* erros (functions and codes for error handling)
* HAPP (functions for creating HAPP headers on demand and manipulating HAPP images)
* log (macros and data for sending messages through the Hexagon messaging system)
* macros (useful macros for global use when making assembly system calls, such as open();)
* sistema (functions and data for hardcoded version management in applications)
* verUtils (functions to process files in OCL format and get version and update data dynamically)
