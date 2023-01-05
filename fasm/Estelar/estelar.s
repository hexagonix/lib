;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2023 Felipe Miguel Nery Lunkes
;; │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘          Todos os direitos reservados
;; ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
;; └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
;;              ┌─┘│                 Licenciado sob licença BSD-3-Clause
;;              └──┘          
;;
;;
;;************************************************************************************
;;
;; Este arquivo é licenciado sob licença BSD-3-Clause. Observe o arquivo de licença 
;; disponível no repositório para mais informações sobre seus direitos e deveres ao 
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
;;
;;************************************************************************************
;;
;; Cabeçalho de macros, estruturas, funções e chamadas para o desenvolvimento de 
;; aplicativos e utilitários
;;
;;************************************************************************************
;;
;;              Biblioteca de desenvolvimento Estelar para Hexagonix®
;;
;; Versão:  2 rev 2  (20/02/2021)
;; Compatibilidade: Hexagonix® 1.14+ (22/11/2020)
;;
;;************************************************************************************

Andromeda.Estelar.Versao:

.versao: db 1
.subver: db 0
.string: db "Estelar versao 1.5 [ALPHA]", 0

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

    Hexagonix limparTela

    mov eax, corTextoTitulo
    mov ebx, corTitulo
    
    Hexagonix definirCor
    
    mov al, 0
    
    Hexagonix limparLinha
    
    mov esi, titulo
    
    imprimirString
    
    mov eax, corTextoRodape
    mov ebx, corRodape
    
    Hexagonix definirCor

    mov al, byte[Andromeda.Interface.numLinhas] ;; Última linha
    
    dec al
    
    Hexagonix limparLinha
    
    mov esi, rodape
    
    imprimirString
    
    mov eax, corTexto
    mov ebx, corFundo
    
    Hexagonix definirCor
    
    mov dl, 2
    mov dh, 1
    
    Hexagonix definirCursor

}

macro Andromeda.Estelar.atualizarResolucao
{

    Hexagonix obterCor

    mov dword[Andromeda.Interface.corFonte], eax
    mov dword[Andromeda.Interface.corFundo], ebx

    Hexagonix obterResolucao

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
    
    Hexagonix definirCor
    
    mov al, byte[Andromeda.Interface.barraCarregamentoY]
    
    Hexagonix limparLinha

    mov eax, dword[Andromeda.Interface.corFonte]
    mov ebx, dword[Andromeda.Interface.corFundo]
    
    Hexagonix definirCor

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
    
    Hexagonix desenharBloco

    mov eax, dword[Andromeda.Interface.barraCarregamentoAdd]
    add dword[Andromeda.Interface.barraCarregamentoPorcentagem], eax

;; Vamos também salvar a informação de porcentagem, para não estourar 100%

    mov eax, porcentagem
    add dword[Andromeda.Interface.barraCarregamentoStatus], eax

}

macro Andromeda.Estelar.excluirBarraCarregamento ;; Não necessita de parâmetros
{

    mov al, byte[Andromeda.Interface.barraCarregamentoY]

    Hexagonix limparLinha

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
    
    Hexagonix desenharBloco
 
.segundaLinha:

    mov eax, 89           ;; Posição X
    mov ebx, 30           ;; Posição Y
    mov esi, 20           ;; Comprimento
    mov edi, 150          ;; Altura
    mov edx, corLogotipo  ;; Cor
    
    Hexagonix desenharBloco
    
.terceiraLinha:

    mov eax, 39           ;; Posição X
    mov ebx, 90           ;; Posição Y
    mov esi, 50           ;; Comprimento
    mov edi, 30           ;; Altura
    mov edx, corLogotipo  ;; Cor
    
    Hexagonix desenharBloco    

    mov dh, 02
    mov dl, 14
    
    Hexagonix definirCursor

    mov eax, corLogotipo
    mov ebx, corFundoAposLogotipo

    Hexagonix definirCor

    mov al, 't'

    Hexagonix imprimirCaractere

    mov al, 'm'

    Hexagonix imprimirCaractere

    mov eax, corTextoAposLogotipo
    mov ebx, corFundoAposLogotipo

    Hexagonix definirCor

}

macro Andromeda.Estelar.finalizarProcessoGrafico codigoErroGrafico, tipoSaidaGrafico
{

    Hexagonix limparTela

    mov eax, codigoErroGrafico
    mov ebx, tipoSaidaGrafico

    Hexagonix encerrarProcesso

}

macro Andromeda.Estelar.imprimirCentralizado mensagem, linha
{

    Hexagonix obterInfoTela

;; BL - Número de colunas
;; BH - Número de linhas

    movxz bx, bl

    push ebx 

    mov esi, mensagem

    Hexagonix tamanhoString

;; Em AX, o tamanho da String

    pop ebx 

    div ax, bx

    div ax, 2

    mov dl, ah
    mov dh, linha

    Hexagonix definirCursor

    mov esi, mensagem

    imprimirString
    
}

;;************************************************************************************

;;************************************************************************************
;;
;;     Cores e definições para uso na montagem de interfaces em modo gráfico
;;
;;   Aviso! Estas são apenas algumas cores recomendadas para utilização na montagem
;;                     de interfaces gráficas para o Hexagonix®
;;
;;************************************************************************************

;; Lista de cores que podem ser utilizadas no design de interfaces do sistema

;; Cor            | Código

;; Escala de cinza

PRETO                = 0x000000
CINZA                = 0x808080
CINZA_ESCURO         = 0xA9A9A9
CINZA_ANDROMEDA      = 0xFF808080
CINZA_CLARO          = 0xD3D3D3
PRATA                = 0xC0C0C0
BRANCO_ANDROMEDA     = 0xFFFFFF
BRANCO_PURO          = 0xFDFEFE

;; Escala de azul

AZUL_NAVY            = 0x000080
AZUL_MEDIO           = 0x0000CD
AZUL_ROYAL           = 0x4169E1
AZUL_CEU             = 0x87CEEB
AZUL                 = 0x0000FF
AZUL_ESCURO          = 0x00008B
CIANO                = 0x00FFFF
CIANO_ESCURO         = 0x008B8B
TURQUESA             = 0x40E0D0
TURQUESA_ESCURO      = 0x00CED1
VERDE_AGUA           = 0x20B2AA
AQUAMARINE           = 0x7FFFD4
AQUAMARINE_ESCURO    = 0x66CDAA
AZUL_CADET           = 0x5F9EA0
AZUL_METALICO        = 0x4682B4
AZUL_NOTURNO         = 0x191970
AZUL_CALMANTE        = 0x2980B9

;; Escala de verde

VERDE                = 0x008000
VERDE_PRIMAVERA      = 0x00FF7F
VERDE_CLARO          = 0x90EE90
VERDE_ESCURO         = 0x006400
VERDE_AMARELADO      = 0x9ACD32
VERDE_MAR            = 0x2E8B57
VERDE_PAZ            = 0x2ECC71
VERDE_MAR_ESCURO     = 0x8FBC8F
VERDE_FLORESTA       = 0x228B22
LIMA                 = 0x00FF00
OLIVA                = 0x808000
OLIVA_ESCURO         = 0x556B2F
VERDE_ANDROMEDA      = 0xff00f000

;; Escala do marrom

CAQUI_ESCURO         = 0xBDB76B
MARROM               = 0x8B4513
MARROM_OURO          = 0xDAA520
MARROM_NAVAJO        = 0xFFDEAD
TRIGO                = 0xF5DEB3
MARROM_PERU          = 0xCD853F
BRONZE               = 0xD35400

;; Escala do roxo

ROXO                 = 0x800080
INDIGO               = 0x4B0082
VIOLETA              = 0x8A2BE2
VIOLETA_ESCURO       = 0x9400D3
MAGENTA              = 0xFF00FF
ROXO_ESCURO          = 0x9932CC  
LAVANDA_SURPRESA     = 0x4A235A

;; Escala do vermelho

CORAL                = 0xFF7F50
VERMELHO             = 0xFF0000
VERMELHO_ESCURO      = 0x8B0000
VERMELHO_TIJOLO      = 0xB22222
SALMAO               = 0xFA8072
SALMAO_CLARO         = 0xFFA07A
TOMATE               = 0xFF6347
VERMELHO_HEXA        = 0xB03A2E
VERMELHO_GABRIEL     = 0xD4553A

;; Escala do laranja

LARANJA              = 0xFFA500
LARANJA_ESCURO       = 0xFF8C00 ;; Cor padrão do Hexagonix®
LARANJA_VERMELHO     = 0xFF4500

;; Escala do amarelo

AMARELO              = 0xFFFF00
AMARELO_VIVO         = 0xF1C40F 
AMARELO_OURO         = 0xFFD700
CAQUI                = 0xF0E68C
AMARELO_ESCURO       = 0xB7950B
AMARELO_ANDROMEDA    = 0xF5A700

;; Escala de tons pastéis
;;
;; Preferencialmente utilizar com fontes de cores escuras

AZUL_PASTEL          = 0xE0FFFF
AMARELO_CLARO_PASTEL = 0xFFFFE0
LIMAO_PASTEL         = 0xFFFACD
PESSEGO_PASTEL       = 0xFFDAB9
VERDE_PASTEL         = 0xEEE8AA
LAVANDA_PASTEL       = 0xE6E6FA
TURQUESA_PASTEL      = 0xE0FFFF
ASTERACEAE_PASTEL    = 0xD8BFD8
MOCASSIM_PASTEL      = 0xFFE4B5
AZURE_PASTEL         = 0xF0FFFF
AZUL_PO_PASTEL       = 0xB0E0E6

;; Fim deste arquivo
