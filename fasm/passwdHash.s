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
;; Shared password hashing and /etc/shadow lookup, used by login, su, adduser,
;; passwd and deluser
;;
;; Compatibility: Hexagonix Mineru or higher
;;                Hexagon 1.7.0 or newer (kernel version required)
;;                Version: 1.1 rev 0 07/08/2026
;;
;;************************************************************************************

Hexagon.LibASM.PasswdHash.file:
db "/etc/shadow", 0

Hexagon.LibASM.PasswdHash.searchSizeLimit = 8192
Hexagon.LibASM.PasswdHash.lineBufferSize  = 128

;;************************************************************************************

;; Computes a DJB2 hash of a plaintext string and writes it as an 8-digit
;; lowercase hex string to Hexagon.LibASM.PasswdHash.hashBuffer. Not a
;; cryptographic hash. No salt, reversible by brute force, but the password
;; is no longer sitting in /etc/shadow as plain readable text.
;;
;; Input:
;;
;; ESI - Plaintext string (NUL-terminated)
;;
;; Output:
;;
;; Hexagon.LibASM.PasswdHash.hashBuffer - 8 lowercase hex chars, NUL-terminated
;;
;; Clobbers EAX, EBX, ECX, EDX, ESI, EDI

Hexagon.LibASM.PasswdHash.hash:

    mov eax, 5381

.accumulate:

    movzx ebx, byte[esi]

    cmp bl, 0
    je .toHex

    mov ecx, eax

    shl eax, 5

    add eax, ecx

    add eax, ebx

    inc esi

    jmp .accumulate

.toHex:

    mov edi, Hexagon.LibASM.PasswdHash.hashBuffer

    mov ecx, 8

.hexDigit:

    rol eax, 4

    mov ebx, eax

    and ebx, 0Fh

    mov dl, byte[.hexDigits + ebx]

    mov byte[edi], dl

    inc edi

    loop .hexDigit

    mov byte[edi], 0

    ret

.hexDigits:
db "0123456789abcdef"

Hexagon.LibASM.PasswdHash.hashBuffer:
times 9 db 0

;;************************************************************************************

;; Looks up a username's record in /etc/shadow (username:passwordhash:code:shell:theme)
;;
;; Input:
;;
;; ESI - Username to search for (NUL-terminated)
;;
;; Output:
;;
;; CF set if not found (including if /etc/shadow itself is missing)
;; CF clear if found, with these filled in:
;;
;; Hexagon.LibASM.PasswdHash.hashFound  - password hash, 8 hex chars + NUL
;; Hexagon.LibASM.PasswdHash.codeFound  - user code (555/777), as an integer
;; Hexagon.LibASM.PasswdHash.shellFound - shell filename
;; Hexagon.LibASM.PasswdHash.themeFound - theme name ("dark"/"light")

Hexagon.LibASM.PasswdHash.findUser:

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov [.wantedUser], esi

    mov esi, Hexagon.LibASM.PasswdHash.file
    mov edi, Hexagon.LibASM.PasswdHash.fileBuffer

    xor ecx, ecx

    hx.syscall hx.open

    jc .notFound

    mov esi, Hexagon.LibASM.PasswdHash.fileBuffer

    mov dword[.readPos], 0

.lineLoop:

    mov edi, Hexagon.LibASM.PasswdHash.lineBuffer

.copyChar:

    lodsb

    inc dword[.readPos]

    cmp dword[.readPos], Hexagon.LibASM.PasswdHash.searchSizeLimit
    jae .notFound

    cmp al, 0
    je .lastLine

    cmp al, 10
    je .lineComplete

;; Skip CR outright, same reasoning as Apps/Unix/init/init.asm's parseConfig:
;; hx.trimString only strips spaces, not carriage returns

    cmp al, 13
    je .copyChar

    mov byte[edi], al

    inc edi

    cmp edi, Hexagon.LibASM.PasswdHash.lineBuffer + Hexagon.LibASM.PasswdHash.lineBufferSize - 1
    jae .lineComplete

    jmp .copyChar

.lineComplete:

    mov byte[edi], 0

    push esi

    call .tryLine

    pop esi

    jc .lineLoop

    pop es

    clc

    ret

.lastLine: ;; End of the file, possibly without a trailing newline

    mov byte[edi], 0

    call .tryLine

    jc .notFound

    pop es

    clc

    ret

.notFound:

    pop es

    stc

    ret

;;************************************************************************************

;; Splits Hexagon.LibASM.PasswdHash.lineBuffer on ':' and, if the first field
;; matches .wantedUser, fills in hashFound/codeFound/shellFound/themeFound
;;
;; Output: CF set if this line's username didn't match

.tryLine:

    mov dword[.cursor], Hexagon.LibASM.PasswdHash.lineBuffer

    mov edi, .fieldBuffer

    call .copyField ;; Field 1: username

    mov edi, .fieldBuffer
    mov esi, [.wantedUser]

    hx.syscall hx.compareWordsString

    jnc .noMatch

;; Username matches, parse the remaining fields straight into their real
;; destinations

    mov edi, Hexagon.LibASM.PasswdHash.hashFound

    call .copyField ;; Field 2: password hash

    mov edi, .fieldBuffer

    call .copyField ;; Field 3: user code, arrives as text

    mov esi, .fieldBuffer

    hx.syscall hx.stringToInt

    mov [Hexagon.LibASM.PasswdHash.codeFound], eax

    mov edi, Hexagon.LibASM.PasswdHash.shellFound

    call .copyField ;; Field 4: shell

    mov edi, Hexagon.LibASM.PasswdHash.themeFound

    call .copyField ;; Field 5: theme

    clc

    ret

.noMatch:

    stc

    ret

;;************************************************************************************

;; Copies characters from .cursor into [EDI] until ':' or NUL is reached,
;; NUL-terminating the destination, and advances .cursor past the ':' (or
;; leaves it on the NUL if this was the last field on the line)
;;
;; Input: EDI - Destination buffer

.copyField:

    mov esi, [.cursor]

.copyFieldLoop:

    lodsb

    cmp al, 0
    je .copyFieldEnd

    cmp al, ':'
    je .copyFieldColon

    stosb

    jmp .copyFieldLoop

.copyFieldColon:

    mov byte[edi], 0

    mov [.cursor], esi

    ret

.copyFieldEnd:

    mov byte[edi], 0

    dec esi

    mov [.cursor], esi

    ret

.wantedUser: dd 0
.cursor:     dd 0
.readPos:    dd 0

.fieldBuffer:
times 32 db 0

Hexagon.LibASM.PasswdHash.hashFound:
times 9 db 0

Hexagon.LibASM.PasswdHash.codeFound:
dd 0

Hexagon.LibASM.PasswdHash.shellFound:
times 12 db 0

Hexagon.LibASM.PasswdHash.themeFound:
times 8 db 0

Hexagon.LibASM.PasswdHash.lineBuffer:
times Hexagon.LibASM.PasswdHash.lineBufferSize db 0

Hexagon.LibASM.PasswdHash.fileBuffer:
times 8192 db 0

;;************************************************************************************

;; Input:
;;
;; ESI - Source string (NUL-terminated)
;; EDI - Destination buffer
;; Copies and NUL-terminates. Clobbers EAX, ECX

Hexagon.LibASM.PasswdHash.copyString:

    push esi
    push edi

    hx.syscall hx.stringSize

    pop edi
    pop esi

    mov ecx, eax

    rep movsb

    mov byte[edi], 0

    ret

;;************************************************************************************

;; Input:
;;
;; ESI - Source string (NUL-terminated)
;; EDI - Current write position
;;
;; Output:
;;
;; EDI advanced past the copied bytes, not NUL-terminated, since
;; callers use this to build up a larger buffer piece by piece. Clobbers
;; EAX, ECX

Hexagon.LibASM.PasswdHash.appendString:

    push esi

    hx.syscall hx.stringSize

    pop esi

    mov ecx, eax

    rep movsb

    ret

;;************************************************************************************

;; Rewrites /etc/shadow: the line whose first field matches ESI is either
;; replaced with the NUL-terminated content at EDI (Apps/Unix/passwd, to
;; change a hash field) or dropped entirely if EDI is 0 (Apps/Unix/deluser).
;; Every other line is copied through unchanged
;;
;; Input:
;;
;; ESI - Username to match
;; EDI - Replacement line (NUL-terminated, no leading/trailing newline), or
;;       0 to drop the matched line
;;
;; Output:
;;
;; CF set if the user wasn't found in /etc/shadow, or the write failed

Hexagon.LibASM.PasswdHash.rewriteUser:

    push es

    push ds ;; User mode data segment (38h selector)
    pop es

    mov [.rwWantedUser], esi
    mov [.rwReplacement], edi

    mov dword[.rwFound], 0

    mov esi, Hexagon.LibASM.PasswdHash.file
    mov edi, Hexagon.LibASM.PasswdHash.fileBuffer

    xor ecx, ecx

    hx.syscall hx.open

    jc .rwFailed

    mov dword[.readPos], 0

    mov dword[.rwOutPos], Hexagon.LibASM.PasswdHash.rwOutput

.rwLineLoop:

    mov edi, Hexagon.LibASM.PasswdHash.lineBuffer

.rwCopyChar:

    mov esi, Hexagon.LibASM.PasswdHash.fileBuffer

    add esi, [.readPos]

    lodsb

    inc dword[.readPos]

    cmp dword[.readPos], Hexagon.LibASM.PasswdHash.searchSizeLimit
    jae .rwFailed

    cmp al, 0
    je .rwLastLine

    mov byte[edi], al

    inc edi

    cmp al, 10
    je .rwLineComplete

    jmp .rwCopyChar

.rwLineComplete:

    mov byte[edi], 0 ;; Hexagon.LibASM.PasswdHash.lineBuffer now holds this line, its own newline included

    call .rwProcessLine

    jmp .rwLineLoop

.rwLastLine:

;; The NUL just read ends the file. If this last "line" is genuinely empty
;; (the file ended right after the previous newline), there is nothing left
;; to process

    cmp edi, Hexagon.LibASM.PasswdHash.lineBuffer
    je .rwFinish

    mov byte[edi], 0

    call .rwProcessLine

.rwFinish:

    mov edi, [.rwOutPos]

    mov byte[edi], 0

    cmp dword[.rwFound], 0
    je .rwFailed

    mov esi, Hexagon.LibASM.PasswdHash.file

    hx.syscall hx.unlink

    mov esi, Hexagon.LibASM.PasswdHash.rwOutput

    hx.syscall hx.stringSize

    mov esi, Hexagon.LibASM.PasswdHash.file
    mov edi, Hexagon.LibASM.PasswdHash.rwOutput

    hx.syscall hx.create

    jc .rwFailed

    pop es

    clc

    ret

.rwFailed:

    pop es

    stc

    ret

;;************************************************************************************

;; Decides whether Hexagon.LibASM.PasswdHash.lineBuffer (one raw line, its
;; own trailing newline included, NUL-terminated) matches .rwWantedUser, and
;; writes the right thing to [.rwOutPos], advancing it

.rwProcessLine:

    mov esi, Hexagon.LibASM.PasswdHash.lineBuffer
    mov edi, .rwLineUser

.rwExtractUser:

    lodsb

    cmp al, ':'
    je .rwUserExtracted

    cmp al, 10
    je .rwUserExtracted

    cmp al, 0
    je .rwUserExtracted

    stosb

    jmp .rwExtractUser

.rwUserExtracted:

    mov byte[edi], 0

    mov edi, .rwLineUser
    mov esi, [.rwWantedUser]

    hx.syscall hx.compareWordsString

    jnc .rwCopyThrough

;; This line matches, either replace it or drop it entirely

    mov dword[.rwFound], 1

    cmp dword[.rwReplacement], 0
    je .rwDropped ;; Apps/Unix/deluser: write nothing for this line

    mov esi, [.rwReplacement]
    mov edi, [.rwOutPos]

    call Hexagon.LibASM.PasswdHash.appendString

    mov byte[edi], 10

    inc edi

    mov [.rwOutPos], edi

.rwDropped:

    ret

.rwCopyThrough:

;; No match, copy Hexagon.LibASM.PasswdHash.lineBuffer through unchanged,
;; its own newline already included

    mov esi, Hexagon.LibASM.PasswdHash.lineBuffer
    mov edi, [.rwOutPos]

    call Hexagon.LibASM.PasswdHash.appendString

    mov [.rwOutPos], edi

    ret

.rwWantedUser:   dd 0
.rwReplacement:  dd 0
.rwFound:        dd 0
.rwOutPos:       dd 0
.readPos:        dd 0

.rwLineUser:
times 32 db 0

Hexagon.LibASM.PasswdHash.rwOutput:
times 8192 db 0
