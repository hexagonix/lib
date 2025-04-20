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
;; Macros and functions for handling Hexagonix version data
;;
;; Compatibility: Hexagonix System I or higher
;;                Hexagon 1.01 or newer (kernel version required)
;;                Version: 2.0 rev 2 29/08/2024
;;
;;************************************************************************************

;;************************************************************************************
;;
;; This file contains useful definitions for system-wide use
;;
;; These settings include the system version as well as data useful to all
;;  Hexagonix applications
;;
;; Important settings for using these functions
;;
;; appFileBuffer: end of program code
;;
;; File format:
;;
;; [Version]Code name"Build#Date and Time!Build>

use32

searchLimit = 8192

getHexagonixVersion:

    pusha

    push es

    push ds
    pop es

    mov esi, versionFileVerUtils
    mov edi, appFileBuffer

    hx.syscall hx.open

    jc .error

    mov si, appFileBuffer ;; Points to the buffer with the file contents
    mov bx, 0FFFFh ;; Starts at position -1, so you can find the delimiters

.searchBetweenDelimiters:

    inc bx

    mov word[positionBXVerUtils], bx

    cmp bx, searchLimit
    je .error ;; If nothing is found within the size limit, cancel the search

    mov al, [ds:si+bx]

    cmp al, '['
    jne .searchBetweenDelimiters ;; The initial limiter has been found

;; BX now points to the first character of the system version

    push ds
    pop es

    mov di, versionObtained ;; The version will be copied to ES:DI

    mov si, appFileBuffer

    add si, bx ;; Move SI to where BX points

    mov bx, 0 ;; Start at 0

.getVersion:

    inc bx

    cmp bx, 64
    je .error ;; If the version is longer than 64 characters, it is invalid

    mov al, [ds:si+bx]

    cmp al, ']' ;; If another delimiter is found, the version has been recovered
    je .versionObtained

;; If not ready, store the obtained character

    stosb

    jmp .getVersion

.versionObtained:

    pop es

    popa

    jmp getDistributionCode

    ret

.error:

    pop es

    popa

    mov eax, 01h

    stc

    ret

;;************************************************************************************

getDistributionCode:

    pusha

    push es

    push ds
    pop es

    mov esi, versionFileVerUtils
    mov edi, appFileBuffer

    hx.syscall hx.open

    jc .error

    mov si, appFileBuffer     ;; Points to the buffer with the file contents
    mov bx, word [positionBXVerUtils] ;; Continue where the previous option left off

    dec bx

.searchBetweenDelimiters:

    inc bx

    mov word[positionBXVerUtils], bx

    cmp bx, searchLimit

    je .error ;; If nothing is found within the size limit, cancel the search

    mov al, [ds:si+bx]

    cmp al, ']'
    jne .searchBetweenDelimiters ;; The initial limiter has been found

;; BX now points to the first character of the codename retrieved from the file

    push ds
    pop es

    mov di, codeObtained ;; The code name will be copied to ES:DI

    mov si, appFileBuffer

    add si, bx ;; Move SI to where BX points

    mov bx, 0 ;; Start at 0

.getCode:

    inc bx

    cmp bx, 64
    je .error ;; If greater than 64, it is invalid

    mov al, [ds:si+bx]

    cmp al, '"' ;; If another delimiter is found, the code name
    je .codeObtained ;; has been completely recovered

;; If not ready, store the obtained character

    stosb

    jmp .getCode

.codeObtained:

    pop es

    popa

    jmp getUpdatePackage

    ret

.error:

    pop es

    popa

    mov eax, 02h

    stc

    ret

;;************************************************************************************

getUpdatePackage:

    pusha

    push es

    push ds
    pop es

    mov esi, versionFileVerUtils
    mov edi, appFileBuffer

    hx.syscall hx.open

    jc .error

    mov si, appFileBuffer     ;; Points to the buffer with the file contents
    mov bx, word [positionBXVerUtils] ;; Continue where the previous option left off

    dec bx

.searchBetweenDelimiters:

    inc bx

    mov word[positionBXVerUtils], bx

    cmp bx, searchLimit

    je .error ;; If nothing is found within the size limit, cancel the search

    mov al, [ds:si+bx]

    cmp al, '"'
    jne .searchBetweenDelimiters ;; The initial limiter has been found

;; BX now points to the first character of the system update package

    push ds
    pop es

    mov di, updatePackage ;; The package will be copied to ES:DI

    mov si, appFileBuffer

    add si, bx ;; Move SI to where BX points

    mov bx, 0 ;; Start at 0

.getPackage:

    inc bx

    cmp bx, 64
    je .error ;; If greater than 64, it is invalid

    mov al, [ds:si+bx]

    cmp al, '#' ;; If it finds another delimiter, it has been loaded successfully
    je .packageObtained

;; If not ready, store the obtained character

    stosb

    jmp .getPackage

.packageObtained:

    pop es

    popa

    jmp getDistributionRelease

.error:

    pop es

    popa

    mov eax, 03h

    stc

    ret

;;************************************************************************************

getDistributionRelease:

    pusha

    push es

    push ds
    pop es

    mov esi, versionFileVerUtils
    mov edi, appFileBuffer

    hx.syscall hx.open

    jc .error

    mov si, appFileBuffer     ;; Points to the buffer with the file contents
    mov bx, word [positionBXVerUtils] ;; Continue where the previous option left off

    dec bx

.searchBetweenDelimiters:

    inc bx

    mov word[positionBXVerUtils], bx

    cmp bx, searchLimit

    je .error ;; If nothing is found within the size limit, cancel the search

    mov al, [ds:si+bx]

    cmp al, '#'
    jne .searchBetweenDelimiters ;; The initial limiter has been found

;; BX now points to the first character of the release

    push ds
    pop es

    mov di, release ;; It will be copied to ES:DI

    mov si, appFileBuffer

    add si, bx ;; Move SI to where BX points

    mov bx, 0 ;; Start at 0

.getRelease:

    inc bx

    cmp bx, 64
    je .error ;; If greater than 64, it is invalid

    mov al, [ds:si+bx]

    cmp al, '!' ;; If it finds another delimiter, it has been loaded successfully
    je .releaseObtained

;; If not ready, store the obtained character

    stosb

    jmp .getRelease

.releaseObtained:

    pop es

    popa

    jmp getDistributionBuild

    ret

.error:

    pop es

    popa

    mov eax, 04h

    stc

    ret

;;************************************************************************************

getDistributionBuild:

    pusha

    push es

    push ds
    pop es

    mov esi, versionFileVerUtils
    mov edi, appFileBuffer

    hx.syscall hx.open

    jc .error

    mov si, appFileBuffer     ;; Points to the buffer with the file contents
    mov bx, word [positionBXVerUtils] ;; Continue where the previous option left off

    dec bx

.searchBetweenDelimiters:

    inc bx

    mov word[positionBXVerUtils], bx

    cmp bx, searchLimit

    je .error ;; If nothing is found within the size limit, cancel the search

    mov al, [ds:si+bx]

    cmp al, '!'
    jne .searchBetweenDelimiters ;; The initial limiter has been found

;; BX now points to the first character of the system build

    push ds
    pop es

    mov di, buildObtained ;; ES:DI will be copied

    mov si, appFileBuffer

    add si, bx ;; Move SI to where BX points

    mov bx, 0 ;; Start at 0

.getBuild:

    inc bx

    cmp bx, 64
    je .error ;; If file name greater than 64, it is invalid

    mov al, [ds:si+bx]

    cmp al, '>' ;; If it finds another delimiter, it has been loaded successfully
    je .buildObtained

;; If not ready, store the obtained character

    stosb

    jmp .getBuild

.buildObtained:

    pop es

    popa

    ret

.error:

    pop es

    popa

    mov eax, 04h

    stc

    ret

;;************************************************************************************

versionFileVerUtils:
db "HEXGNIX.OCL", 0
versionObtained:
times 64 db 0
codeObtained:
times 64 db 0
updatePackage:
times 64 db 0
release:
times 64 db 0
buildObtained:
times 64 db 0
positionBXVerUtils:
dw 0