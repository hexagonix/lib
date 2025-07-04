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
;;                     Sistema Operacional Hexagonix - Hexagonix Operating System
;;
;;                         Copyright (c) 2015-2025 Felipe Miguel Nery Lunkes
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
;; Copyright (c) 2015-2025, Felipe Miguel Nery Lunkes
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
;; Macros for console manipulation
;;
;; Compatibility: Hexagonix System I or higher
;;                Hexagon 1.01 or newer (kernel version required)
;;                Version: 1.0 rev 2 29/08/2024
;;
;;************************************************************************************

;; Save information about the console in use

macro saveConsole
{

    hx.syscall hx.getConsoleInfo

    mov byte[Lib.Console.maxColumns], bl
    mov byte[Lib.Console.maxLines], bh

    hx.syscall hx.getColor

    mov dword[Lib.Console.fontColor], eax
    mov dword[Lib.Console.backgroundColor], ebx

    hx.syscall hx.getResolution

    mov dword[Lib.Console.resolution], eax

}

;; Restore information about the current console

macro restoreConsole
{

    mov eax, dword[Lib.Console.fontColor]
    mov ebx, dword[Lib.Console.backgroundColor]

    hx.syscall hx.setColor

    mov eax, dword[Lib.Console.resolution]

    hx.syscall hx.setResolution

}

;; Macro to change console color set

macro setConsoleColor consoleFontColor, consoleBackgroundColor
{

    mov eax, consoleFontColor
    mov ebx, consoleBackgroundColor

    hx.syscall hx.setColor

}

;; Restore the console color set

macro restoreConsoleColor
{

    mov eax, dword[Lib.Console.fontColor]
    mov ebx, dword[Lib.Console.backgroundColor]

    hx.syscall hx.setColor

}

;; Restores default console behavior and clears the console

macro restoreAndClearConsole
{

    restoreConsole

    hx.syscall hx.clearConsole

}

macro putNewLine
{

    push ebx

    xor ebx, ebx

    mov al, 10 ;; 10 is the newline character

    pop ebx

    hx.syscall hx.printCharacter

}

;; Macro to display an integer in the console

macro printInteger
{

    mov ebx, 01h

    hx.syscall hx.print

}

;; Macro to display a hexadecimal number in the console

macro printHexadecimal
{

    mov ebx, 02h

    hx.syscall hx.print

}

;; Macro to display a binary number in the console

macro printBinary
{

    mov ebx, 03h

    hx.syscall hx.print

}

;; Macro to display a string in the console

macro printString
{

    mov ebx, 04h

    hx.syscall hx.print

}

;; fputs macro does not add a new line after sending content to the console

macro fputs string ;; Macro used to print content on the console
{

    mov esi, string

    printString

}

;; The puts macro adds a new line after sending the content to the console

macro puts string ;; Macro used to print content on the console
{

    mov esi, string

    printString

    putNewLine

}

;; The gotoxy macro is used to change to a specific row or column in the console

macro gotoxy x, y
{

    mov dl, x
    mov dh, y

    hx.syscall hx.setCursor

}

;; The xyfputs macro changes to a specific row and column and sends the content
;; passed as a parameter to the console

macro xyfputs x, y, string ;; Macro used to print content on the console
{

    gotoxy x, y

    mov esi, string

    printString

}

;;************************************************************************************

;; Hexagonix themes, used since startup

;; Color | HEX code

;; Hexagonix Default Theme

HEXAGONIX_DEFAULT_BACKGROUND = HEXAGONIX_BLOSSOM_CINZA
HEXAGONIX_DEFAULT_FONT_COLOR = HEXAGONIX_BLOSSOM_AMARELO

;; Blossom Theme (System Default)

HEXAGONIX_BLOSSOM_CINZA          = 0x29282928
HEXAGONIX_BLOSSOM_AMARELO        = 0x00C7B898
HEXAGONIX_BLOSSOM_AMARELO_CLARO  = 0x00FFFFE0
HEXAGONIX_BLOSSOM_VERDE_CLARO    = 0x00659B64
HEXAGONIX_BLOSSOM_VERDE_ESCURO   = 0x00466246
HEXAGONIX_BLOSSOM_AZUL           = 0x00E0FFFF
HEXAGONIX_BLOSSOM_LIMAO          = 0x00FFFACD
HEXAGONIX_BLOSSOM_PESSEGO        = 0x00FFDAB9
HEXAGONIX_BLOSSOM_VERDE          = 0x00B7CE77
HEXAGONIX_BLOSSOM_LAVANDA        = 0x00E6E6FA
HEXAGONIX_BLOSSOM_TURQUESA       = 0x00E0FFFF
HEXAGONIX_BLOSSOM_ASTERACEAE     = 0x00D8BFD8
HEXAGONIX_BLOSSOM_MOCASSIM       = 0x00FFE4B5
HEXAGONIX_BLOSSOM_AZUL           = 0x004682B4
HEXAGONIX_BLOSSOM_AZURE          = 0x00F0FFFF
HEXAGONIX_BLOSSOM_AZUL_PO        = 0x00B0E0E6
HEXAGONIX_BLOSSOM_AZUL_ANDROMEDA = 0x005A9DA6
HEXAGONIX_BLOSSOM_LARANJA        = 0x00EDA050
HEXAGONIX_BLOSSOM_VERMELHO       = 0x00E5665D
HEXAGONIX_BLOSSOM_ROSA           = 0x00FFCCEA
HEXAGONIX_BLOSSOM_ROXO           = 0x00C38CA7

;; Classic Hexagonix Theme (deprecated)

HEXAGONIX_CLASSICO_PRETO  = 0x00000000
HEXAGONIX_CLASSICO_BRANCO = 0xFFFFFFFF

;;************************************************************************************

;; List of colors that can be used in system interface design

;; Color | HEX code

;; Hexagonix default colors (taken from the system logo)

MARROM_HEXAGONIX   = 0xC3765B
CAQUI_HEXAGONIX    = 0xF2D2BE
TERRA_HEXAGONIX    = 0x9A5743
NUDE_HEXAGONIX     = 0xDBAF9E
ROXO_HEXAGONIX     = 0x7C4454
ROXO_ESC_HEXAGONIX = 0x371429
AMARELO_HEXAGONIX  = 0xFBCB04
OURO_HEXAGONIX     = 0xAF7F11
CINZENTO_HEXAGONIX = 0xCBB5B9

;; Grey scale

PRETO            = 0x000000
CINZA            = 0x808080
CINZA_ESCURO     = 0xA9A9A9
CINZA_ANDROMEDA  = 0xFF8080
CINZA_CLARO      = 0xD3D3D3
PRATA            = 0xC0C0C0
BRANCO_ANDROMEDA = 0xFFFFFF
BRANCO_PURO      = 0xFDFEFE

;; Blue scale

AZUL_PURO         = 0x0000FF
AZUL_80           = 0x9999FF
AZUL_65           = 0x4D4DFF
AZUL_30           = 0x000099
AZUL_NAVY         = 0x000080
AZUL_MEDIO        = 0x0000CD
AZUL_ROYAL        = 0x4169E1
AZUL_CEU          = 0x87CEEB
AZUL              = 0x0000FF
AZUL_ESCURO       = 0x00008B
CIANO             = 0x00FFFF
CIANO_ESCURO      = 0x008B8B
TURQUESA          = 0x40E0D0
TURQUESA_ESCURO   = 0x00CED1
VERDE_AGUA        = 0x20B2AA
AQUAMARINE        = 0x7FFFD4
AQUAMARINE_ESCURO = 0x66CDAA
AZUL_CADET        = 0x5F9EA0
AZUL_NOTURNO      = 0x191970
AZUL_CALMANTE     = 0x2980B9

;; Green scale

VERDE_75         = 0x80FFAA
VERDE_60         = 0x33FF77
VERDE_40         = 0x00CC44
VERDE_30         = 0x009933
VERDE            = 0x008000
VERDE_PRIMAVERA  = 0x00FF7F
VERDE_CLARO      = 0x90EE90
VERDE_ESCURO     = 0x006400
VERDE_AMARELADO  = 0x9ACD32
VERDE_MAR        = 0x2E8B57
VERDE_PAZ        = 0x2ECC71
VERDE_MAR_ESCURO = 0x8FBC8F
VERDE_FLORESTA   = 0x228B22
LIMA             = 0x00FF00
OLIVA            = 0x808000
OLIVA_ESCURO     = 0x556B2F

;; Brown scale

CAQUI_ESCURO  = 0xBDB76B
MARROM        = 0x8B4513
MARROM_OURO   = 0xDAA520
MARROM_NAVAJO = 0xFFDEAD
MARROM_JAVA   = 0x873E23
TRIGO         = 0xF5DEB3
MARROM_PERU   = 0xCD853F
BRONZE        = 0xD35400

;; Purple scale

ROXO_PURO        = 0x660066
ROXO_70          = 0xFF66FF
ROXO_60          = 0xFF33FF
ROXO_50          = 0xFF00FF
ROXO_45          = 0xE600E6
ROXO             = 0x800080
INDIGO           = 0x4B0082
VIOLETA          = 0x8A2BE2
VIOLETA_ESCURO   = 0x9400D3
MAGENTA          = 0xFF00FF
ROXO_ESCURO      = 0x9932CC
LAVANDA_SURPRESA = 0x4A235A

;; Red scale

CORAL            = 0xFF7F50
VERMELHO         = 0xFF0000
VERMELHO_ESCURO  = 0x8B0000
VERMELHO_TIJOLO  = 0xB22222
SALMAO           = 0xFA8072
SALMAO_CLARO     = 0xFFA07A
TOMATE           = 0xFF6347
VERMELHO_HEXA    = 0xB03A2E
VERMELHO_GABRIEL = 0xD4553A

;; Pink scale

ROSA_CHOQUE = 0xFF0080
ROSA_70     = 0xFF66B3
ROSA_60     = 0xFF3399
ROSA_35     = 0xB30059

;; Orange scale

LARANJA_PURO     = 0xFF6600
LARANJA_70       = 0xFFA366
LARANJA_55       = 0xFF751A
LARANJA          = 0xFFA500
LARANJA_ESCURO   = 0xFF8C00 ;; Hexagonix default color
LARANJA_VERMELHO = 0xFF4500

;; Yellow scale

OURO              = 0xFFCC00
GEMA              = 0xE6B800
AMARELO_80        = 0xFFEB99
AMARELO_70        = 0xFFE066
AMARELO_60        = 0xFFD633
AMBAR             = 0xFF9900
AMARELO           = 0xFFFF00
AMARELO_VIVO      = 0xF1C40F
AMARELO_OURO      = 0xFFD700
CAQUI             = 0xF0E68C
AMARELO_ESCURO    = 0xB7950B
AMARELO_ANDROMEDA = 0xF5A700

;;************************************************************************************

Lib.Console:

.maxColumns:      db 0
.maxLines:        db 0
.backgroundColor: dd 0
.fontColor:       dd 0
.resolution:      dd 0

;; A quick guide to the resolution field, responsible for storing the code related to the resolution in
;; use or to be implemented. Options can be:
;;
;; 1 - Resolution of 800x600 pixels
;; 2 - Resolution of 1024x768 pixels
;; 3 - Text mode

;; End of this file
