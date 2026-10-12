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
;;                         Copyright (c) 2015-2026 Felipe Miguel Nery Lunkes
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
;; Copyright (c) 2015-2026, Felipe Miguel Nery Lunkes
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
;; Compatibility: Hexagonix 1.1 or higher
;;                Hexagon 1.8.0 or newer (kernel version required)
;;                Version: 5.0 rev 0 13/09/2026
;;
;;************************************************************************************

;;************************************************************************************
;;
;; This file contains useful definitions for system-wide use
;;
;; These settings include the system version as well as data useful to all
;; Hexagonix applications
;;
;; File format:
;;
;; One key=value pair per line. Blank lines and lines starting with '#' are ignored,
;; and a key the file carries that nothing here asks for is ignored too:
;;
;; version=1.1
;; codename=Hylia
;; updatePack=1.1
;; branch=Hylia
;; buildId=f89a32d5-d3db-49a5-a3b7-29bba177c6f5

use32

;; Room each field below holds, terminator included

VERUTILS_FIELD = 64

;; Error codes returned in EAX when CF comes back set

VERUTILS_UNREADABLE = 01h ;; The file is not on the volume, or is empty
VERUTILS_NOMEMORY   = 02h ;; Not enough memory to hold the file
VERUTILS_READERROR  = 03h ;; The file is there but could not be read
VERUTILS_MISSINGKEY = 04h ;; The file does not carry one of the keys below

;;************************************************************************************

;; Reads /etc/hexgnix.cfg into memory it allocates and fills every field below
;; from it. Nothing is left allocated once it returns
;;
;; Output:
;;
;; CF - Set if the version data could not be read, with the code in EAX

getHexagonixVersion:

    pusha
    push es

    push ds
    pop es

    mov esi, verUtils.versionFile

    hx.syscall hx.stat

    jc .unreadable

    cmp eax, 0
    je .unreadable

    mov dword[verUtils.fileSize], eax

    inc eax ;; Room for the terminator the parser stops on

    mov dword[verUtils.allocated], eax
    mov ebx, eax

    call malloc

    cmp eax, 0
    je .noMemory

    mov dword[verUtils.buffer], ebx
    mov edi, ebx
    mov esi, verUtils.versionFile
    mov ecx, dword[verUtils.fileSize]

    hx.syscall hx.open

    jc .readError

    mov edi, dword[verUtils.buffer]

    add edi, dword[verUtils.fileSize]

    mov byte[edi], 0
    mov esi, verUtils.keyVersion
    mov edi, versionObtained

    call verUtils.readKey

    jc .missingKey

    mov esi, verUtils.keyCodename
    mov edi, codeObtained

    call verUtils.readKey

    jc .missingKey

    mov esi, verUtils.keyUpdatePack
    mov edi, updatePackage

    call verUtils.readKey

    jc .missingKey

    mov esi, verUtils.keyBranch
    mov edi, release

    call verUtils.readKey

    jc .missingKey

    mov esi, verUtils.keyBuildId
    mov edi, buildObtained

    call verUtils.readKey

    jc .missingKey

    call verUtils.releaseBuffer

    pop es
    popa

    clc

    ret

.missingKey:

    call verUtils.releaseBuffer

    pop es
    popa

    mov eax, VERUTILS_MISSINGKEY

    stc

    ret

.readError:

    call verUtils.releaseBuffer

    pop es

    popa

    mov eax, VERUTILS_READERROR

    stc

    ret

.noMemory:

    pop es

    popa

    mov eax, VERUTILS_NOMEMORY

    stc

    ret

.unreadable:

    pop es

    popa

    mov eax, VERUTILS_UNREADABLE

    stc

    ret

;;************************************************************************************

;; Gives back the memory the file was read into

verUtils.releaseBuffer:

    push eax
    push ebx
    push ecx

    mov ebx, dword[verUtils.buffer]
    mov ecx, dword[verUtils.allocated]

    call free

    mov dword[verUtils.buffer], 0

    pop ecx
    pop ebx
    pop eax

    ret

;;************************************************************************************

;; Copies the value of one key into a field, reading the file already sitting
;; in verUtils.buffer
;;
;; Input:
;;
;; ESI - Key to look for, terminated by a 0
;; EDI - Field to fill, of VERUTILS_FIELD bytes
;;
;; Output:
;;
;; CF - Set if the file carries no such key, leaving the field empty

verUtils.readKey:

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    mov ebp, esi ;; The key itself, since ESI walks it once per line
    mov edx, dword[verUtils.buffer] ;; Start of the line being looked at

.lineLoop:

    mov al, byte[edx]

    cmp al, 0
    je .noSuchKey

    cmp al, '#'
    je .nextLine

    cmp al, 13
    je .nextLine

    cmp al, 10
    je .nextLine

    mov esi, ebp
    mov ebx, edx

.compareKey:

    mov al, byte[esi]

    cmp al, 0
    je .keyMatched

    mov ah, byte[ebx]

    cmp al, ah
    jne .nextLine

    inc esi
    inc ebx

    jmp .compareKey

.keyMatched:

;; The line has to carry the whole key and nothing else before the '=', so a
;; longer key starting with this one is not taken for it

    cmp byte[ebx], '='
    jne .nextLine

    inc ebx

    mov ecx, VERUTILS_FIELD - 1

.copyValue:

    cmp ecx, 0
    je .valueCopied

    mov al, byte[ebx]

    cmp al, 0
    je .valueCopied

    cmp al, 13
    je .valueCopied

    cmp al, 10
    je .valueCopied

    mov byte[edi], al

    inc ebx
    inc edi

    dec ecx

    jmp .copyValue

.valueCopied:

    mov byte[edi], 0

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    clc

    ret

.nextLine:

    mov al, byte[edx]

    cmp al, 0
    je .noSuchKey

    inc edx

    cmp al, 10
    jne .nextLine

    jmp .lineLoop

.noSuchKey:

    mov byte[edi], 0

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    stc

    ret

;;************************************************************************************

verUtils.versionFile:
db "/etc/hexgnix.cfg", 0
verUtils.keyVersion:
db "version", 0
verUtils.keyCodename:
db "codename", 0
verUtils.keyUpdatePack:
db "updatePack", 0
verUtils.keyBranch:
db "branch", 0
verUtils.keyBuildId:
db "buildId", 0

verUtils.buffer:    dd 0
verUtils.fileSize:  dd 0
verUtils.allocated: dd 0

versionObtained:
times VERUTILS_FIELD db 0
codeObtained:
times VERUTILS_FIELD db 0
updatePackage:
times VERUTILS_FIELD db 0
release:
times VERUTILS_FIELD db 0
buildObtained:
times VERUTILS_FIELD db 0
