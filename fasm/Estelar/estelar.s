;;*************************************************************************************************
;;
;; 88                                                                                88              
;; 88                                                                                ""              
;; 88                                                                                                
;; 88,dPPPba,   ,adPPPba, 8b,     ,d8 ,adPPPPba,  ,adPPPb,d8  ,adPPPba,  8b,dPPPba,  88 8b,     ,d8  
;; 88P'    "88 a8P     88  `P8, ,8P'  ""     `P8 a8"    `P88 a8"     "8a 88P'   `"88 88  `P8, ,8P'   
;; 88       88 8PP"""""""    )888(    ,adPPPPP88 8b       88 8b       d8 88       88 88    )888(     
;; 88       88 "8b,   ,aa  ,d8" "8b,  88,    ,88 "8a,   ,d88 "8a,   ,a8" 88       88 88  ,d8" "8b,   
;; 88       88  `"Pbbd8"' 8P'     `P8 `"8bbdP"P8  `"PbbdP"P8  `"PbbdP"'  88       88 88 8P'     `P8  
;;                                               aa,    ,88                                         
;;                                                "P8bbdP"       
;;
;;                    Sistema Operacional Hexagonix® - Hexagonix® Operating System
;;
;;                          Copyright © 2015-2023 Felipe Miguel Nery Lunkes
;;                        Todos os direitos reservados - All rights reserved.
;;
;;*************************************************************************************************
;;
;; Português:
;; 
;; O Hexagonix e seus componentes são licenciados sob licença BSD-3-Clause. Leia abaixo
;; a licença que governa este arquivo e verifique a licença de cada repositório para
;; obter mais informações sobre seus direitos e obrigações ao utilizar e reutilizar
;; o código deste ou de outros arquivos.
;;
;; English:
;;
;; Hexagonix and its components are licensed under a BSD-3-Clause license. Read below
;; the license that governs this file and check each repository's license for
;; obtain more information about your rights and obligations when using and reusing
;; the code of this or other files.
;;
;;*************************************************************************************************
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
;; Cabeçalho de macros, estruturas, funções e chamadas para o desenvolvimento de 
;; aplicativos e utilitários
;;
;;************************************************************************************
;;
;;              Biblioteca de desenvolvimento Estelar para Hexagonix®
;;
;; Versão:  1.7-CURRENT (01/03/2023)
;; Compatibilidade: Hexagonix® H1 (22/11/2020)
;;
;;************************************************************************************

include "console.s"

Andromeda.Estelar.Versao:

.versao: db 1
.subver: db 0
.string: db "Estelar versao 1.7-CURRENT", 0

struc Andromeda.Estelar.Interface
{

.numColunas:                   db 0 ;; Total de colunas disponíveis no vídeo na resolução atual
.numLinhas:                    db 0 ;; Total de linhas disponíveis no vídeo na resolução atual
.resolucao:                    db 0 ;; Resolução atual do vídeo
.tema:                         db 0 ;; Tema
.corFundo:                     dd 0 ;; Cor do plano de fundo
.corFonte:                     dd 0 ;; Cor do texto
.destaque:                     dd 0 ;; Cor do destaque
.destaqueFonte:                dd 0 ;; Cor de destaque da fonte
.posicaoX:                     db 0 ;; Posição de X no vídeo
.posicaoY:                     db 0 ;; Posição de Y no vídeo
.cursorX:                      db 0 ;; Posição horizontal do cursor
.cursorY:                      db 0 ;; Posição vertical do cursor

;; Dados para a criação e atualização da barra de carregamento

.barraCarregamentoY:           dd 0 ;; Posição de criação da barra de carregamento
.barraCarregamentoCor:         dd 0 ;; Cor da barra de carregamento
.barraCarregamentoPos:         dd 0 ;; Posição atual da barra de carregamento, para atualização
.barraCarregamentoAdd:         dd 0 ;; Número, em porcentagem, para incrementar a barra
.barraCarregamentoStatus:      dd 0 ;; Status da barra, para verificar se já atingiu o tamanho máximo
.barraCarregamentoPorcentagem: dd 0 ;; O número, em porcentagem
.barraCarregamentoFatorAdicao: dd 0 ;; O fator varia de acordo com a resolução da tela
.barraCarregamentoCorFundo:    dd 0

}

;;************************************************************************************
;;
;;            Definições de tamanho de fonte utilizada pelo Hexagonix®
;;
;;************************************************************************************

Andromeda.Estelar.Tema.Fonte: ;; Definições padrão de cores de plano de fundo e fonte

.fundoPadrao = PRETO
.fontePadrao = BRANCO_ANDROMEDA
.tamanho = 8
.altura  = 16

macro Andromeda.Estelar.criarInterface titulo, rodape, corTitulo, corRodape, corTextoTitulo, corTextoRodape, corTexto, corFundo
{

    hx.syscall limparTela

    mov eax, corTextoTitulo
    mov ebx, corTitulo
    
    hx.syscall definirCor
    
    mov al, 0
    
    hx.syscall limparLinha
    
    fputs titulo
        
    mov eax, corTextoRodape
    mov ebx, corRodape
    
    hx.syscall definirCor

    mov al, byte[Andromeda.Interface.numLinhas] ;; Última linha
    
    dec al
    
    hx.syscall limparLinha
    
    fputs rodape
        
    mov eax, corTexto
    mov ebx, corFundo
    
    hx.syscall definirCor
    
    mov dl, 2
    mov dh, 1
    
    hx.syscall definirCursor

}

macro Andromeda.Estelar.atualizarResolucao
{

    hx.syscall obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

    hx.syscall obterResolucao

    cmp eax, 1
    je .resolucao800x600

    cmp eax, 2
    je .resolucao1024x768

.resolucao800x600:

    mov byte[Andromeda.Interface.resolucao], 01h

    jmp .fim 

.resolucao1024x768:

    mov byte[Andromeda.Interface.resolucao], 02h

    jmp .fim 

.fim:

}

;; Macros para criar, atualizar e excluir uma barra de carregamento [ALPHA]

macro Andromeda.Estelar.criarBarraCarregamento posicaoY, corBarra, corFundo
{

;; Primeiramente, salvar a posição de Y 

    mov dword[Andromeda.Interface.barraCarregamentoY], posicaoY

;; Agora, salvar a cor da barra

    mov dword[Andromeda.Interface.barraCarregamentoCor], corBarra
    mov dword[Andromeda.Interface.barraCarregamentoCorFundo], corFundo

    Andromeda.Estelar.atualizarResolucao

    cmp byte[Andromeda.Interface.resolucao], 01h
    je .resolucao800x600

    cmp byte[Andromeda.Interface.resolucao], 02h
    je .resolucao1024x768

.resolucao800x600:

    mov dword[Andromeda.Interface.barraCarregamentoFatorAdicao], 08

    jmp .fatorDefinido

.resolucao1024x768:

    mov dword[Andromeda.Interface.barraCarregamentoFatorAdicao], 10.24

    jmp .fatorDefinido

.fatorDefinido:

;; Agora vamos criar um fundo que demarca a posição da barra de carregamento
;; na tela, com o preenchimento dela após cada atualização

    mov eax, BRANCO_ANDROMEDA
    mov ebx, dword[Andromeda.Interface.barraCarregamentoCorFundo]
    
    hx.syscall definirCor
    
    mov al, byte[Andromeda.Interface.barraCarregamentoY]
    
    hx.syscall limparLinha

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    hx.syscall definirCor

    Andromeda.Estelar.atualizarBarracarregamento 1

.fim:

;; A barra já foi criada, junto com a demarcação inferior, bem como foi atualizada
;; para preencher ao menos 1%

}

;; Aviso! A barra só cresce da esquerda para a direita e não pode ser decrementada (ainda)

macro Andromeda.Estelar.atualizarBarracarregamento porcentagem
{

;; Primeiro, devemos ver se a barra de carregamento já atingiu 100%. Em caso
;; afirmativo, não devemos continuar, uma vez que isso seria um estouro na barra

    cmp dword[Andromeda.Interface.barraCarregamentoStatus], 100
    jng .continuar

    jmp .estouroFim

;; Caso seja menor que 100, podemos atualizar a barra

.continuar:

;; Agora devemos computar os dados de adição em porcentagem com base no fator de
;; resolução e o valor fornecido pelo aplicativo gráfico

    mov eax, dword[Andromeda.Interface.barraCarregamentoFatorAdicao]
    mov ebx, porcentagem

    mul ebx 

    add eax, dword[Andromeda.Interface.barraCarregamentoPorcentagem]

    mov dword[Andromeda.Interface.barraCarregamentoAdd], eax 

    mov eax, dword[Andromeda.Interface.barraCarregamentoPorcentagem] ;; Posição X
    mov ebx, dword[Andromeda.Interface.barraCarregamentoY] ;; Posição Y
    mov esi, dword[Andromeda.Interface.barraCarregamentoAdd] ;; Comprimento
    mov edi, 16 ;; Altura
    mov edx, dword[Andromeda.Interface.barraCarregamentoCor] ;; Cor
    
    hx.syscall desenharBloco

    mov eax, dword[Andromeda.Interface.barraCarregamentoAdd]
    add dword[Andromeda.Interface.barraCarregamentoPorcentagem], eax

;; Vamos também salvar a informação de porcentagem, para não estourar 100%

    mov eax, porcentagem
    add dword[Andromeda.Interface.barraCarregamentoStatus], eax

}

macro Andromeda.Estelar.excluirBarraCarregamento ;; Não necessita de parâmetros
{

    mov al, byte[Andromeda.Interface.barraCarregamentoY]

    hx.syscall limparLinha

}

;; Fim das rotinas de manipulação de barras de carregamento [ALPHA]

;; Agora uma barra de carregamento típica para ser usada em modo texto 
;; \|/--

macro Andromeda.Estelar.barraCarregamentoTexto tempo
{

;; A ser feito

}

macro Andromeda.Estelar.criarLogotipo corLogotipo, corFundoLogotipo, corTextoAposLogotipo, corFundoAposLogotipo
{

;; Desenhar um bloco de cor específica
;; Entrada: EAX - X; EBX - Y; ESI - Comprimento
;; Entrada: EDI - Altura; EDX - Cor em hexadecimal

.primeiraLinha:
    
    mov eax, 20           ;; Posição X
    mov ebx, 30           ;; Posição Y
    mov esi, 20           ;; Comprimento
    mov edi, 150          ;; Altura
    mov edx, corLogotipo  ;; Cor
    
    hx.syscall desenharBloco
 
.segundaLinha:

    mov eax, 89           ;; Posição X
    mov ebx, 30           ;; Posição Y
    mov esi, 20           ;; Comprimento
    mov edi, 150          ;; Altura
    mov edx, corLogotipo  ;; Cor
    
    hx.syscall desenharBloco
    
.terceiraLinha:

    mov eax, 39           ;; Posição X
    mov ebx, 90           ;; Posição Y
    mov esi, 50           ;; Comprimento
    mov edi, 30           ;; Altura
    mov edx, corLogotipo  ;; Cor
    
    hx.syscall desenharBloco    

    mov dh, 02
    mov dl, 14
    
    hx.syscall definirCursor

    mov eax, corLogotipo
    mov ebx, corFundoAposLogotipo

    hx.syscall definirCor

    mov eax, corTextoAposLogotipo
    mov ebx, corFundoAposLogotipo

    hx.syscall definirCor

}

macro Andromeda.Estelar.finalizarProcessoGrafico codigoErroGrafico, tipoSaidaGrafico
{

    hx.syscall limparTela

    mov eax, codigoErroGrafico
    mov ebx, tipoSaidaGrafico

    hx.syscall encerrarProcesso

}

macro Andromeda.Estelar.imprimirCentralizado mensagem, linha
{

    hx.syscall obterInfoTela

;; BL - Número de colunas
;; BH - Número de linhas

    movxz bx, bl

    push ebx 

    mov esi, mensagem

    hx.syscall tamanhoString

;; Em AX, o tamanho da String

    pop ebx 

    div ax, bx

    div ax, 2

    mov dl, ah
    mov dh, linha

    hx.syscall definirCursor

    fputs mensagem
    
}

;;************************************************************************************

;; Fim deste arquivo
