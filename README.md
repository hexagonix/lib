<p align="center">
<img src="https://github.com/hexagonix/Doc/blob/main/Img/banner.png">
</p>

<div align="center">

![](https://img.shields.io/github/license/hexagonix/lib.svg)
![](https://img.shields.io/github/stars/hexagonix/lib.svg)
![](https://img.shields.io/github/issues/hexagonix/lib.svg)
![](https://img.shields.io/github/issues-closed/hexagonix/lib.svg)
![](https://img.shields.io/github/issues-pr/hexagonix/lib.svg)
![](https://img.shields.io/github/issues-pr-closed/hexagonix/lib.svg)
![](https://img.shields.io/github/downloads/hexagonix/lib/total.svg)
![](https://img.shields.io/github/release/hexagonix/lib.svg)

</div>

<!-- Vai funcionar como <hr> -->

<img src="https://github.com/hexagonix/Doc/blob/main/Img/hr.png" width="100%" height="2px" />

<details title="English" align='left'>
<br>
<summary align='left'><strong>English</strong></summary>

# libasm - Libraries for Hexagonix Assembly Development

<div align="justify">

This repository contains important libraries and macros for developing utilities for Hexagonix.

Libasm libraries are classified into `Hexagonix` libraries and `Estelar` libraries (formerly Andromeda libraries). The `Hexagonix` libraries are responsible for allowing utilities and applications access to the API exposed by the system, either Hexagon system calls (kernel) or other functions in the user environment. The `Estelar` libraries are responsible for exposing useful functions for the development of text-based graphical interfaces (TUI) and graphical interfaces (GUI) on top of Hexagonix. The graphics libraries consist of core-mode functions exposed by Hexagon, as well as user-mode functions implemented in the libraries themselves. Libraries may be available for compatible assemblers (flat assembler and NASM).

</div>

### Hexagonix Libraries

<div align="justify">

The `Hexagonix` libraries comprise several components that allow the application to interact with Hexagon, other applications and standard devices. So far, Hexagonix libraries consist of the following files:

* `hexagon.s`: library that allows the application to make system calls to Hexagon, using the API exposed by the kernel;
* `devices.s`: provides device names and data used in system calls;
* `errors.s`: functions and code for error handling, as well as standard error definitions;
* `HAPP.s`: functions for creating HAPP headers on demand and manipulating HAPP images in user mode;
* `log.s`: macros and data for sending messages through the Hexagon messaging system;
* `macros.s`: useful macros for global use when making assembly system calls, such as open();
* `verUtils.s`: functions to process files in OCL format and dynamically obtain system version and update data from supported utilities.

</div>

### Estelar Libraries

<div align="justify">

The `Estelar` libraries are inside the Estelar directory, and are composed of the following files, so far:

* `estelar.s`: standard library for rendering and graphical manipulation;
* `bigbang.s`: standard library for handling compatible sound devices.

</div>

### Utility implementation example

<div align="justify">

You can find utility implementation examples in [text mode](example/tapp.asm) and [graphic](example/gapp.asm) to analyze their construction. Feel free to open an `issue` to settle any debt or report any errors.

</div>

</details>

<details title="Português (Brasil)" align='left'>
<br>
<summary align='left'><strong>Português (Brasil)</strong></summary>

# libasm - Bibliotecas para desenvolvimento em Assembly do Hexagonix

<div align="justify">

Este repositório contém bibliotecas e macros importantes para o desenvolvimento de utilitários para o Hexagonix.

As bibliotecas da libasm são classificadas em bibliotecas `Hexagonix` e bibliotecas `Estelar` (antigas bibliotecas Andromeda). As bibliotecas `Hexagonix` são responsáveis por permitir o acesso dos utilitários e aplicativos à API exposta pelo sistema, seja chamadas de sistema do Hexagon (kernel) ou outras funções em ambiente de usuário. Já as bibliotecas `Estelar` são responsáveis por expor funções úteis para o desenvolvimento de interfces gráficas baseadas em texto (TUI) e interfaces gráficas (GUI) sobre o Hexagonix. As bibliotecas gráficas consistem de funções em modo núcleo expostas pelo Hexagon, bem como funções em modo usuário implementadas nas próprias bibliotecas. As bibliotecas podem estar disponíveis para os montadores compatíveis (flat assembler e NASM).

</div>

### Bibliotecas Hexagonix

<div align="justify">

As bibliotecas `Hexagonix` compreendem vários componentes que permitem ao aplicativo interagir com o Hexagon, outros aplicativos e com dispositivos padrão. Até o momento, as bibliotecas Hexagonix são constituídas pelos seguintes arquivos:

* `hexagon.s`: biblioteca que permite ao aplicativo realizar chamadas de sistema ao Hexagon, usando a API exposta pelo kernel;
* `dispositivos.s`: fornece nomes e dados de dispositivos utilizados em chamadas de sistema;
* `erros.s`: funções e códigos para manipulação de erros, bem como definições de erros padrão;
* `HAPP.s`: funções para criação de cabeçalhos HAPP sob demanda e manipulação de imagens HAPP em modo usuário;
* `log.s`: macros e dados para enviar mensagens pelo sistema de mensagens do Hexagon;
* `macros.s`: macros úteis para uso global ao realizar chamadas de sistema em assembly, como abrir();
* `verUtils.s`: funções para processar arquivos no formato OCL e obter dados de versão e atualização do sistema de forma dinâmica pelos utilitários compatíveis.

</div>

### Bibliotecas Estelar

<div align="justify">

As bibliotecas `Estelar` estão dentro do diretório Estelar, e são compostas pelos seguintes arquivos, até o momento:

* `estelar.s`: biblioteca padrão para renderização e manipulação gráfica;
* `bigbang.s`: biblioteca padrão para manipular dispositivos de som compatíveis.

</div>

### Exemplo de implementação de utilitários

<div align="justify">

Você pode encontrar exemplos de implementação de utilitários em [modo texto](exemplo/tapp.asm) e [gráfico](exemplo/gapp.asm) para analisar sua construção. Sinta-se a vontade de abrir uma `issue` para sanar qualquer dívida ou relatar algum errro.

</div>

</details>
