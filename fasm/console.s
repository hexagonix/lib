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

;; Salvar as informações sobre o console em uso

macro salvarConsole
{

    hx.syscall obterInfoTela
    
    mov byte[Lib.Console.maxColunas], bl
    mov byte[Lib.Console.maxLinhas], bh

    hx.syscall obterCor

    mov dword[Lib.Console.corFonte], eax 
    mov dword[Lib.Console.corFundo], ebx

    hx.syscall obterResolucao

    mov dword[Lib.Console.resolucao], eax

}

;; Restaurar informações sobre o console atual

macro restaurarConsole
{

    mov eax, dword[Lib.Console.corFonte]
    mov ebx, dword[Lib.Console.corFundo]

    hx.syscall definirCor

    mov eax, dword[Lib.Console.resolucao]
    
    hx.syscall definirResolucao

}

;; Macro para alterar o conjunto de cores do console

macro definirCorConsole consoleCorFonte, consoleCorFundo
{

    mov eax, consoleCorFonte
    mov ebx, consoleCorFundo

    hx.syscall definirCor

}

;; Restaurar o conjunto de cores do console

macro restaurarCorConsole
{

    mov eax, dword[Lib.Console.corFonte]
    mov ebx, dword[Lib.Console.corFundo]

    hx.syscall definirCor

}

;; Restaura o comportamento padrão do console e limpar o terminal

macro restaurarConsoleLimpar
{

    restaurarConsole

    hx.syscall limparTela

}

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

AZUL_PURO            = 0x0000FF
AZUL_80              = 0x9999FF
AZUL_65              = 0x4D4DFF
AZUL_30              = 0x000099
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

VERDE_75             = 0x80FFAA
VERDE_60             = 0x33FF77
VERDE_40             = 0x00CC44
VERDE_30             = 0x009933
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
MARROM_JAVA          = 0x873E23
TRIGO                = 0xF5DEB3
MARROM_PERU          = 0xCD853F
BRONZE               = 0xD35400

;; Escala do roxo

ROXO_PURO            = 0x660066
ROXO_70              = 0xFF66FF
ROXO_60              = 0xFF33FF
ROXO_50              = 0xFF00FF
ROXO_45              = 0xE600E6
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

;; Escala do rosa

ROSA_CHOQUE          = 0xFF0080
ROSA_70              = 0xFF66B3
ROSA_60              = 0xFF3399
ROSA_35              = 0xB30059

;; Escala do laranja

LARANJA_PURO         = 0xFF6600
LARANJA_70           = 0xFFA366
LARANJA_55           = 0xFF751A
LARANJA              = 0xFFA500
LARANJA_ESCURO       = 0xFF8C00 ;; Cor padrão do Hexagonix®
LARANJA_VERMELHO     = 0xFF4500

;; Escala do amarelo

OURO                 = 0xFFCC00
GEMA                 = 0xE6B800
AMARELO_80           = 0xFFEB99
AMARELO_70           = 0xFFE066
AMARELO_60           = 0xFFD633
AMBAR                = 0xFF9900
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

;;************************************************************************************

Lib.Console:

.maxColunas: db 0
.maxLinhas:  db 0
.corFundo:   dd 0
.corFonte:   dd 0
.resolucao:  dd 0

;; Um guia rápido sobre o campo resolução, responsável por armazenar o código relativo
;; à resolução em uso ou a ser implementada. As opções podem ser:
;;
;; 1 - Resolução de 800x600 pixels
;; 2 - Resolução de 1024x768 pixels
;; 3 - Modo texto

;; Fim deste arquivo