# Bibliotecas para o desenvolvimento de aplicativos e utilitários

Este repositório contém bibliotecas e macros importantes para o desenvolvimento de utilitários para o Hexagonix e Andromeda.

## Aviso de direitos autorais

Veja a [Licença](LICENSE) para mais informações.

## Bibliotecas Andromeda

As bibliotecas exclusivas para apps Andromeda estão dentro do diretório Estelar, e contam com as seguintes bibliotecas, até o momento:

* Estelar (biblioteca padrão para renderização e manipulação gráfica)
* Big Bang (biblioteca padrão para manipular dispositivos de som e emitir notas)

## Bibliotecas Hexagon

As bibliotecas Hexagon compreendem vários componentes que permitem ao aplicativo interagir com o Hexagon, outros aplicativos e com dispositivos padrão. Até o momento, as bibliotecas Hexagon são:

* hexagon (biblioteca que permite ao aplicativo realizar chamadas de sistema ao Hexagon, usando a API exposta)
* dispositivos (fornece nomes e dados de dispositivos utilizados em chamadas de sistema)
* erros (funções e códigos para manipulação de erros)
* HAPP (funções para criação de cabeçalhos HAPP sob demanda e manipulação de imagens HAPP)
* log (macros e dados para enviar mensagens pelo sistema de mensagens do Hexagon)
* macros (macros úteis para uso global ao realizar chamadas de sistema em assembly, como abrir();)
* sistema (funções e dados para gerenciamento de versão hardcoded em aplicativos)
* verUtils (funções para processar arquivos no formato OCL e obter dados de versão e atualização de forma dinâmica)

Versão deste arquivo: 1.1
