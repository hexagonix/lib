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
;;                         Copyright (c) 2015-2024 Felipe Miguel Nery Lunkes
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
;; Copyright (c) 2015-2024, Felipe Miguel Nery Lunkes
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
;; This is a template for building a graphical app for Hexagonix!
;;
;; Written by Felipe Miguel Nery Lunkes on 04/12/2020
;;
;; You can generate an executable HAPP image using the fasm assembler
;; included. To do this, use the command line below:
;;
;; fasmX gapp.asm
;; or
;; fasmX gapp.asm gapp.app

;; Now, let's define the format of the generated image. As fasmX doesn't
;; has native support for the HAPP format, let's generate a simple binary image
;; and add the format specific information with the header defined below,
;; indirectly generating a valid HAPP image.

format binary as " " ;; Specifies the file format and extension

use32

headerHAPP:

;; HAPP2 specification (HAPP 2.0 rev 0)

signature:     db "HAPP" ;; Image signature
architecture:  db 01h    ;; Image architecture (i386 = 01h)
minVer:        db 1      ;; Minimum version of Hexagon(R)
minMinorVer:   db 00     ;; Minimal subversion of Hexagon(R)
entryPoint:    dd applicationStart ;; Image entry point
imageType:     db 01h ;; Image type
reserved0:     dd 0 ;; Reserved (Dword)
reserved1:     db 0 ;; Reserved (Byte)
reserved2:     db 0 ;; Reserved (Byte)
reserved3:     db 0 ;; Reserved (Byte)
reserved4:     dd 0 ;; Reserved (Dword)
reserved5:     dd 0 ;; Reserved (Dword)
reserved6:     dd 0 ;; Reserved (Dword)
reserved7:     db 0 ;; Reserved (Byte)
reserved8:     dw 0 ;; Reserved (Word)
reserved9:     dw 0 ;; Reserved (Word)
reserved10:    dw 0 ;; Reserved (Word)

;;*************************************************************

include "hexagon.s" ;; Include system calls
include "estelar.s" ;; Includes interface creation library

;;*************************************************************

;; Variables and constants

VERSION equ "3.3" ;; Application version

gapp:

.helloMessage: ;; Place the dbs below to facilitate organization
db 10, 10, "This is an example of a graphical HAPP application from Hexagonix!", 10, 10
db 10, 10, "Press any key to exit...", 10, 10, 0

.TITLE:
db "Welcome!", 0

.FOOTER:
db "[", VERSION, "] | Press any key to continue...", 0

.tty0:
db "tty0", 0 ;; Default console

;;************************************************************************************

applicationStart:

;; Let's define that we want direct output to tty0 (similar to tty0 in Linux).
;; This is not always necessary. If the shell was used to call the app, tty0 is already open.
;; Unless it is called by an app that is using, for example, tty1.
;; tty0 is the main console while tty1-ttyn are virtual consoles.

    mov esi, gapp.tty0

    hx.syscall hx.open ;; Open device

;; Okay, now let's continue. First, clear the console and get resolution information

    Andromeda.Estelar.getConsoleInfo

    hx.syscall hx.clearConsole

;; Let's create the interface structure with title and footer

;; Format for receiving parameters from the create interfaces function:
;; It is worth mentioning that the parameters must be in order!
;;
;; title, footer, title color, footer color, text color in the title,
;; footer text color, app initial text color, initial background color
;;
;; You can use '\' to break the line if it is too long, as below

    Andromeda.Estelar.createInterface gapp.TITLE, gapp.FOOTER, VERMELHO_TIJOLO,\
    VERMELHO_TIJOLO, BRANCO_ANDROMEDA, BRANCO_ANDROMEDA,\
    [Andromeda.Interface.fontColor], [Andromeda.Interface.backgroundColor]

;; Now let's print a simple message on the interface

    fputs gapp.helloMessage

;; We will wait for user interaction to finalize the app

    hx.syscall hx.waitKeyboard

;; Did you interact? Ok, let's finish the application

;; Format:
;;
;; Error code (in this case, 0), exit type (read documentation in macro - in this case, 0)

    Andromeda.Estelar.finishGraphicProcess 0, 0
