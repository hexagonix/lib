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
;; Estelar development library for Hexagonix
;;
;; Compatibility: Hexagonix System I or higher
;;                Hexagon 1.01 or newer (kernel version required)
;;                Version: 2.0 rev 2 29/08/2025
;;
;;************************************************************************************

include "console.s"

Andromeda.Estelar.Version:

.verion: db 1
.subver: db 0
.string: db "Estelar version 2.0 rev 2", 0

struc Andromeda.Estelar.Interface
{

.numColumns:      db 0 ;; Total columns available in the video at the current resolution
.numRows:         db 0 ;; Total lines available in the video at the current resolution
.resolution:      db 0 ;; Current video resolution
.theme:           db 0 ;; Theme
.backgroundColor: dd 0 ;; Background color
.fontColor:       dd 0 ;; Text color
.highlight:       dd 0 ;; Highlight color
.fontHighlight:   dd 0 ;; Font accent color
.positionX:       db 0 ;; X position in the console
.positionY:       db 0 ;; Y position in the console
.cursorX:         db 0 ;; Horizontal cursor position
.cursorY:         db 0 ;; Vertical cursor position

}

Andromeda.Interface Andromeda.Estelar.Interface

;;************************************************************************************
;;
;;                     Font size settings used by Hexagonix
;;
;;************************************************************************************

Andromeda.Estelar.Theme.Font: ;; Default background and font color settings

.defaultBackgroundColor = HEXAGONIX_BLOSSOM_CINZA
.defaultFontColor       = HEXAGONIX_BLOSSOM_AMARELO
.length = 8
.height = 16

;;************************************************************************************

macro Andromeda.Estelar.getConsoleInfo
{

    hx.syscall hx.getColor

;; Return the console's default color scheme, not the current one

    mov dword[Andromeda.Interface.fontColor], ecx
    mov dword[Andromeda.Interface.backgroundColor], edx

    hx.syscall hx.getConsoleInfo

    mov byte[Andromeda.Interface.numColumns], bl
    mov byte[Andromeda.Interface.numRows], bh

}

macro Andromeda.Estelar.createInterface title, footer, titleColor, footerColor, titleTextColor, footerTextColor, textColor, backgroundColor
{

    hx.syscall hx.clearConsole

    mov eax, titleTextColor
    mov ebx, titleColor

    hx.syscall hx.setColor

    mov al, 0

    hx.syscall hx.clearLine

    fputs title

    mov eax, footerTextColor
    mov ebx, footerColor

    hx.syscall hx.setColor

    mov al, byte[Andromeda.Interface.numRows] ;; Last line

    dec al

    hx.syscall hx.clearLine

    fputs footer

    mov eax, textColor
    mov ebx, backgroundColor

    hx.syscall hx.setColor

    mov dl, 2
    mov dh, 1

    hx.syscall hx.setCursor

}

macro Andromeda.Estelar.updateResolution
{

    hx.syscall hx.getColor

    mov dword[Andromeda.Interface.fontColor], eax
    mov dword[Andromeda.Interface.backgroundColor], ebx

    hx.syscall hx.getResolution

    cmp eax, 1
    je .resolution800x600

    cmp eax, 2
    je .resolution1024x768

.resolution800x600:

    mov byte[Andromeda.Interface.resolution], 01h

    jmp .end

.resolution1024x768:

    mov byte[Andromeda.Interface.resolution], 02h

    jmp .end

.end:

}

macro Andromeda.Estelar.buildLogo logoColor, logoBackgroundColor, textColorAfterLogo, backgroundColorAfterLogo
{

;; Draw a specific color block
;; Input: EAX - X; EBX - Y; ESI - Length
;; Input: EDI - Height; EDX - Color in hexadecimal

.firstLine:

    mov eax, 20           ;; X position
    mov ebx, 30           ;; Y position
    mov esi, 20           ;; Length
    mov edi, 150          ;; Height
    mov edx, logoColor    ;; Color

    hx.syscall hx.drawBlock

.secondLine:

    mov eax, 89           ;; X position
    mov ebx, 30           ;; Y position
    mov esi, 20           ;; Length
    mov edi, 150          ;; Height
    mov edx, logoColor    ;; Color

    hx.syscall hx.drawBlock

.thirdLine:

    mov eax, 39           ;; X position
    mov ebx, 90           ;; Y position
    mov esi, 50           ;; Length
    mov edi, 30           ;; Height
    mov edx, logoColor    ;; Color

    hx.syscall hx.drawBlock

    mov dh, 02
    mov dl, 14

    hx.syscall hx.setCursor

    mov eax, logoColor
    mov ebx, backgroundColorAfterLogo

    hx.syscall hx.setColor

    mov eax, textColorAfterLogo
    mov ebx, backgroundColorAfterLogo

    hx.syscall hx.setColor

}

macro Andromeda.Estelar.finishGraphicProcess errorCode, exitType
{

    hx.syscall hx.clearConsole

    mov eax, errorCode
    mov ebx, exitType

    hx.syscall hx.exit

}

macro Andromeda.Estelar.printCentered message, line
{

    hx.syscall hx.getConsoleInfo

;; BL - Number of columns
;; BH - Number of lines

    movxz bx, bl

    push ebx

    mov esi, message

    hx.syscall hx.stringSize

;; In AX, the size of the string

    pop ebx

    div ax, bx

    div ax, 2

    mov dl, ah
    mov dh, line

    hx.syscall hx.setCursor

    fputs message

}

;;************************************************************************************

;; End of file
