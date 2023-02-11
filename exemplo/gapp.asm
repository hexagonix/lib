;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2015-2023 Felipe Miguel Nery Lunkes
;; │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘          Todos os direitos reservados
;; ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
;; └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
;;              ┌─┘│                 Licenciado sob licença BSD-3-Clause
;;              └──┘          
;;
;;
;;************************************************************************************
;;
;; Este arquivo e licenciado sob licenca BSD-3-Clause. Observe o arquivo de licenca 
;; disponivel no repositorio para mais informacoes sobre seus direitos e deveres ao 
;; utilizar qualquer trecho deste arquivo.
;;
;; BSD 3-Clause License
;;
;; Copyright (c) 2015-2023, Felipe Miguel Nery Lunkes
;; All rights reserved.
;; 
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;; 
;; 1. Redistributions of source code must retain the above copyright notice, this
;;    list of conditions and the following disclaimer.
;;
;; 2. Redistributions in binary form must reproduce the above copyright notice,
;;    this list of conditions and the following disclaimer in the documentation
;;    and/or other materials provided with the distribution.
;;
;; 3. Neither the name of the copyright holder nor the names of its
;;    contributors may be used to endorse or promote products derived from
;;    this software without specific prior written permission.
;; 
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
;; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;
;; $HexagonixOS$

;;************************************************************************************
;;
;; Este e um template para a construcao de um app de modo grafico para 
;; o Hexagonix(R)!
;;
;; Escrito por Felipe Miguel Nery Lunkes em 04/12/2020
;;
;; Voce pode gerar uma imagem HAPP executavel utilizando o montador
;; FASM incluido. Para isso, utilize a linha de comando abaixo:
;;
;; fasmX gapp.asm
;;       ou
;; fasmX gapp.asm gapp.app

;; Agora, vamos definir o formato da imagem gerada. Como o fasmX nao
;; tem suporte nativo ao formato HAPP, vamos gerar uma imagem binaria
;; simples e vamos adicionar as informacoes especificas do formato com
;; o cabecalho que esta definido abaixo, gerando de forma indireta uma
;; imagem HAPP completa. Tambem vamos definir que o nome da imagem gerada
;; sera o mesmo do arquivo .asm, mas como a extensao .app, que deve ser
;; reconhecida pelo shell. Para isso, devemos usar:
;;
;; format binary as "app". O formato binario ja e o padrao e, caso o
;; usuario insira fasmx gapp.asm gapp.app, toda essa linha pode ser
;; ignorada e a linha abaixo nao precisa estar no codigo.

format binary as "app" ;; Especifica o formato e extensao do arquivo

use32

cabecalhoAPP:

.assinatura:      db "HAPP"    ;; Assinatura
.arquitetura:     db 01h       ;; Arquitetura (i386 = 01h)
.versaoMinima:    db 1         ;; Versao minima do Hexagon(R)
.subversaoMinima: db 00        ;; Subversao minima do Hexagon(R)
.pontoEntrada:    dd inicioAPP ;; Offset do ponto de entrada
.tipoImagem:      db 01h       ;; Imagem executavel
.reservado0:      dd 0         ;; Reservado (Dword)
.reservado1:      db 0         ;; Reservado (Byte)
.reservado2:      db 0         ;; Reservado (Byte)
.reservado3:      db 0         ;; Reservado (Byte)
.reservado4:      dd 0         ;; Reservado (Dword)
.reservado5:      dd 0         ;; Reservado (Dword)
.reservado6:      dd 0         ;; Reservado (Dword)
.reservado7:      db 0         ;; Reservado (Byte)
.reservado8:      dw 0         ;; Reservado (Word)
.reservado9:      dw 0         ;; Reservado (Word)
.reservado10:     dw 0         ;; Reservado (Word)

;;*************************************************************

include "hexagon.s" ;; Incluir as chamadas de sistema
include "estelar.s" ;; Inclui funcoes de criacao de interfaces

;;*************************************************************

;; Variaveis e constantes

;; Agora vamos criar uma instancia da estrutura de controle de interfaces
;; Sintaxe: estrutura para o app (instancia), estrutura original

Andromeda.Interface Andromeda.Estelar.Interface

;; Dentro de gapp estarao todos os dados de texto que serao exibidos ao usuario.

VERSAO equ "1.1" ;; Versao do aplicativo

gapp:

.mensagemOla: db 10, 10, "Este e um exemplo de aplicativo HAPP grafico do Hexagonix(R)!", 10, 10
              db 10, 10, "Pressione qualquer tecla para finalizar este programa...", 10, 10, 0 

.TITULO:      db "Seja bem-vindo!", 0
.RODAPE:      db "[", VERSAO, "] | Pressione qualquer tecla para continuar...", 0                

.vd0:         db "vd0", 0 ;; Console principal

;;************************************************************************************

inicioAPP:

;; Vamos definir que queremos saida direta para vd0 (similar a tty0 no Linux)
;; Isso nem sempre e necessario. Se o shell foi utilizado para chamar o app, 
;; vd0 ja esta aberto. A menos que seja chamado por um app que esteja usando, por
;; exemplo, vd1. vd0 é o console principal, enquanto vd1-vdn são consoles virtuais.

    mov esi, gapp.vd0

    hx.syscall abrir ;; Abrir dispositivo

;; Pronto, agora vamos continuar. Primeiro, limpar a saida e obter informacoes
;; de resolucao

    hx.syscall limparTela

    hx.syscall obterInfoTela
    
    mov byte[Andromeda.Interface.numColunas], bl
    mov byte[Andromeda.Interface.numLinhas], bh

;; Vamos salvar o esquema de cores atual do Sistema, para consistencia
;; Isso e importante para definir se estamos em modo claro ou escuro de
;; interface

    hx.syscall obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

;; Vamos criar a estrutura de interface com titulo e rodape

;; Formato de recebimento de parametros da funcao de criar interfaces:
;; Vale ressaltar que os parametros devem estar na ordem!
;;
;; titulo, rodape, cor do titulo, cor do rodape, cor do texto no titulo,
;; cor do texto no rodape, cor do texto inicial do app, cor de fundo inicial
;;
;; Voce pode utilizar '\' para quebrar a linha, caso esteja muito grande, como
;; abaixo

    Andromeda.Estelar.criarInterface gapp.TITULO, gapp.RODAPE, VERMELHO_TIJOLO,\
    VERMELHO_TIJOLO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA,\
    [Andromeda.Interface.corFonte], [Andromeda.Interface.corFundo]

;; Agora vamos imprimir na interface uma mensagem simples

    mov esi, gapp.mensagemOla

    imprimirString

;; Vamos aguardar interacao do usuario para finalizar o app

    hx.syscall aguardarTeclado

;; Interagiu? Ok, vamos finalizar o app

;; Formato:
;;
;; Codigo de erro (neste caso, 0), tipo de saida (neste caso, 0)

    Andromeda.Estelar.finalizarProcessoGrafico 0, 0
    
;;************************************************************************************

