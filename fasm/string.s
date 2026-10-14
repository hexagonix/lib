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
;; String handling for applications
;;
;; Compatibility: Hexagonix 1.1 or higher
;;                Hexagon 1.8.0 or newer (kernel version required)
;;                Version: 1.0 rev 0 13/09/2026
;;
;;************************************************************************************

;; These were system calls once, which is what putting them in the kernel to
;; avoid writing them twice ends up costing: measuring or trimming a string is
;; arithmetic, needs nothing the kernel alone can do, and every one of them was
;; a ring transition plus a pointer the kernel had to check before writing
;; through it at CPL 0. Here they are a call, and a bad pointer costs the
;; process that passed it and nobody else
;;
;; The kernel keeps its own copies for its own use. It no longer offers them

;; What hexagonHandler used to guarantee before every one of these, and what
;; each has to guarantee for itself now that it is called and not trapped into:
;; ES agreeing with DS, since the moves inside write through ES:EDI and an
;; application's ES is whatever it was last left as, and a clear direction flag
;; both on the way in and on the way out, since two of the bodies set it and
;; never put it back

stringSize:

    push es

    push ds
    pop es

    cld

    call .body

    cld ;; A body may have left it set

    pop es

    ret

.body:

    push ecx
    push esi
    push edi
    push es

    push ds ;; Kernel data segment
    pop es

    mov edi, esi

    or ecx, 0xFFFFFFFF

    xor al, al

    cld ;; Clear direction

    repne scasb ;; Search for end of string in EDI

    or eax, 0xFFFFFFFF

    sub eax, ecx

    dec eax ;; Not including character 0

    pop es
    pop edi
    pop esi
    pop ecx

    ret

;;************************************************************************************

;; Compare first words of two strings
;;
;; Input:
;;
;; ESI - First string
;; EDI - Second string
;;
;; Output:
;;
;; Carry defined if strings are equal

;; What hexagonHandler used to guarantee before every one of these, and what
;; each has to guarantee for itself now that it is called and not trapped into:
;; ES agreeing with DS, since the moves inside write through ES:EDI and an
;; application's ES is whatever it was last left as, and a clear direction flag
;; both on the way in and on the way out, since two of the bodies set it and
;; never put it back

compareWordsInString:

    push es

    push ds
    pop es

    cld

    call .body

    cld ;; A body may have left it set

    pop es

    ret

.body:

    push eax
    push esi
    push edi

.compareLoop:

    mov al, byte[esi]

    cmp al, ' '
    je .isEqual

    cmp al, byte[edi]
    jne .isNotEqual

    cmp byte[edi], 0
    je .isEqual

    inc esi
    inc edi

    jmp .compareLoop

.isNotEqual:

    clc

    jmp .end

.isEqual:

    cmp byte[edi], 0
    jne .isNotEqual

    stc

.end:

    pop edi
    pop esi
    pop eax

    ret

;;************************************************************************************

;; Compare two strings
;;
;; Input:
;;
;; ESI - First string
;; EDI - Second string
;;
;; Output:
;;
;; Carry defined if strings are equal

;; What hexagonHandler used to guarantee before every one of these, and what
;; each has to guarantee for itself now that it is called and not trapped into:
;; ES agreeing with DS, since the moves inside write through ES:EDI and an
;; application's ES is whatever it was last left as, and a clear direction flag
;; both on the way in and on the way out, since two of the bodies set it and
;; never put it back
;;
;; ESI also comes back as it went in, the way the system-call entry in front of
;; it restored it: login reads its own trimmed string straight out of ESI

toUppercase:

    push es

    push ds
    pop es

    cld

    push esi

    call .body

    pop esi

    cld ;; A body may have left it set

    pop es

    ret

.body:

    push eax
    push ecx
    push esi

    mov al, byte[esi]

    cmp al, 0
    je .end

    call stringSize

    mov ecx, eax

.convertLoop:

    mov al, byte[esi]

.check1:

    cmp al, 'a' ;; Check if the character is lowercase
    jae .check2

    inc esi

    loop .convertLoop

    jmp .end

.check2:

    cmp al, 'z' ;; Check if the character is lowercase
    jbe .ok

    inc esi

    loop .convertLoop

    jmp .end

.ok:

    sub al, ' ' ;; Convert if character is lowercase
    mov byte[esi], al

    inc esi

    loop .convertLoop

.end:

    pop esi
    pop ecx
    pop eax

    ret

;;************************************************************************************

;; Convert a string to lowercase
;;
;; Input:
;;
;; ESI - String
;;
;; Output:
;;
;; ESI - Converted string

;; What hexagonHandler used to guarantee before every one of these, and what
;; each has to guarantee for itself now that it is called and not trapped into:
;; ES agreeing with DS, since the moves inside write through ES:EDI and an
;; application's ES is whatever it was last left as, and a clear direction flag
;; both on the way in and on the way out, since two of the bodies set it and
;; never put it back
;;
;; ESI also comes back as it went in, the way the system-call entry in front of
;; it restored it: login reads its own trimmed string straight out of ESI

trimString:

    push es

    push ds
    pop es

    cld

    push esi

    call .body

    pop esi

    cld ;; A body may have left it set

    pop es

    ret

.body:

    push eax
    push ebx
    push ecx
    push esi
    push edi

    push es

    push ds ;; Kernel data segment
    pop es

;; First we need to remove the spaces from the left and then from the right

    cmp byte[esi], 0 ;; If empty string, exit
    je .end

    call stringSize ;; Get string size in EAX

    mov ecx, eax ;; Put this in ECX to use in a loop

    push esi ;; Save position in string for future use
    push ecx ;; Save string size for future use

    xor ebx, ebx ;; EBX is a blank counter

    cld ;; From left to right, then clearing the direction flag

.cutFromLeft:

    lodsb

    cmp al, ' '
    je .cutLeft

    jmp short .noSpaceLeft

.cutLeft:

    inc ebx

    mov byte[esi-1], 0 ;; Fill spaces with 0

    loop .cutFromLeft

.noSpaceLeft:

    pop ecx ;; Restore string size
    pop esi ;; Restore position in string

    push esi
    push ecx

    mov edi, esi
    add esi, ebx ;; Add total blanks spaces

    rep movsb ;; Move string to new position

    pop ecx

    sub ecx, ebx

    pop esi

    add esi, ecx

    dec esi

    std ;; Set direction to decrement from right to left

.cutFromRight:

    lodsb

    cmp al, ' '
    je .cutRight

    jmp short .noSpaceRight

.cutRight:

    mov byte[esi+1], 0 ;; Fill spaces with 0

    loop .cutFromRight

    jmp .end

.noSpaceRight:

.end:

    cld

    pop es
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax

    ret

;;************************************************************************************

;; Convert ASCII integer decimal to integer
;;
;; Input:
;;
;; ESI - String
;;
;; Output:
;;
;; EAX - Integer
;; CF defined in case of incorrect number

;; What hexagonHandler used to guarantee before every one of these, and what
;; each has to guarantee for itself now that it is called and not trapped into:
;; ES agreeing with DS, since the moves inside write through ES:EDI and an
;; application's ES is whatever it was last left as, and a clear direction flag
;; both on the way in and on the way out, since two of the bodies set it and
;; never put it back

stringToInteger:

    push es

    push ds
    pop es

    cld

    call .body

    cld ;; A body may have left it set

    pop es

    ret

.body:

    push ebx
    push ecx
    push edx
    push esi

    mov dword[.number], 0

    mov al, '-'

    call findCharacterInString

    cmp eax, 1
    ja .negative

.positive:

    mov byte[.negativeFlag], 0

    jmp .next

.negative:

    inc esi

    mov byte[.negativeFlag], 1

.next:

    call stringSize ;; Get string size

    mov ecx, eax ;; Use counting in the loop

    add esi, eax

    dec esi

    mov ebx, 0
    mov eax, 1

.convertLoop:

    mov bl, byte[esi]

    dec esi

    sub bl, 30h

    cmp bl, 9
    ja .invalidNumber

    mov edx, 10

    mul edx

    push eax

    mul ebx

    add dword[.number], eax

    pop eax

    loop .convertLoop

    mov ebx, 10
    mov eax, dword[.number]
    mov edx, 0

    div ebx ;; Divide by 10

    mov dword[.number], 0

.successful:

    cmp byte[.negativeFlag], 0
    je .done

    neg eax

.done:

    clc

    jmp short .end

.invalidNumber:

    mov eax, 0

    stc

.end:

    pop esi
    pop edx
    pop ecx
    pop ebx

    ret

.number:       dd 0
.negativeFlag: db 0

;;************************************************************************************

;; Find a particular character in a string
;;
;; Input:
;;
;; ESI - String
;; AL  - Character to search for
;;
;; Output:
;;
;; EAX - Number of occurrences of this character
;; CF set if character not found

;; What hexagonHandler used to guarantee before every one of these, and what
;; each has to guarantee for itself now that it is called and not trapped into:
;; ES agreeing with DS, since the moves inside write through ES:EDI and an
;; application's ES is whatever it was last left as, and a clear direction flag
;; both on the way in and on the way out, since two of the bodies set it and
;; never put it back

findCharacterInString:

    push es

    push ds
    pop es

    cld

    call .body

    cld ;; A body may have left it set

    pop es

    ret

.body:

    push ebx
    push ecx
    push edx
    push esi

    mov bl, al
    xor ecx, ecx

.findLoop:

    lodsb

    or al, al ;; cmp AL, 0 (last character)
    jz .next

    cmp al, bl ;; Character found
    jne .findLoop

    inc ecx ;; Counter

    jmp .findLoop

.next:

    mov eax, ecx

    or eax, eax ;; cmp EDX, 0
    jz .notFound

    clc

    jmp .end

.notFound:

    stc

.end:

    pop esi
    pop edx
    pop ecx
    pop ebx

    ret

;;************************************************************************************

;; Remove a character from a specific position in the string
;;
;; Input:
;;
;; ESI - String
;; EAX - Character position

;; What hexagonHandler used to guarantee before every one of these, and what
;; each has to guarantee for itself now that it is called and not trapped into:
;; ES agreeing with DS, since the moves inside write through ES:EDI and an
;; application's ES is whatever it was last left as, and a clear direction flag
;; both on the way in and on the way out, since two of the bodies set it and
;; never put it back
;;
;; ESI also comes back as it went in, the way the system-call entry in front of
;; it restored it: login reads its own trimmed string straight out of ESI

removeCharacterInString:

    push es

    push ds
    pop es

    cld

    push esi

    call .body

    pop esi

    cld ;; A body may have left it set

    pop es

    ret

.body:

    push edi ;; Overwritten below, and its sibling insertCharacterInString keeps it

    push esi
    push edx

    mov edx, eax

    call stringSize

    cmp edx, eax ;; EAX is the size of the string
    ja .end

    inc eax ;; Including the last null character

    add esi, edx

    push es

    push ds ;; Kernel data segment
    pop es

    mov edi, esi

    inc esi ;; Next character

    mov ecx, eax

    cld ;; Clear direction

    rep movsb ;; Move (ECX) characters from ESI to EDI

    pop es
    pop edx
    pop esi

.end:


    pop edi

    ret

;;************************************************************************************

;; Insert a character in a specific position in the string
;;
;; Input:
;;
;; ESI - String
;; EDX - Character position
;; AL  - Character to insert
;;
;; The string buffer must be large enough!

;; What hexagonHandler used to guarantee before every one of these, and what
;; each has to guarantee for itself now that it is called and not trapped into:
;; ES agreeing with DS, since the moves inside write through ES:EDI and an
;; application's ES is whatever it was last left as, and a clear direction flag
;; both on the way in and on the way out, since two of the bodies set it and
;; never put it back
;;
;; ESI also comes back as it went in, the way the system-call entry in front of
;; it restored it: login reads its own trimmed string straight out of ESI

insertCharacterInString:

    push es

    push ds
    pop es

    cld

    push esi

    call .body

    pop esi

    cld ;; A body may have left it set

    pop es

    ret

.body:

    push eax
    push ebx
    push ecx
    push edi

    mov ebx, eax ;; Save character

    push esi

;; Create space to include the character

    call stringSize

    push eax ;; EAX is the size of the string

    add esi, eax

    inc esi ;; Including null character

    push es

    push ds ;; Kernel data segment
    pop es

    std ;; Reverse direction in rep movsb

    add esi, edx

    dec esi

    mov edi, esi

    dec esi

    mov ecx, eax

    rep movsb ;; Move (ECX) characters from ESI to EDI

    pop es

    pop eax
    pop esi

;; Insert character here

    mov byte[esi+edx], bl ;; BL has the character
    mov byte[esi+eax+1],0 ;; Create end of string

    cld

    pop edi
    pop ecx
    pop ebx
    pop eax

    ret

;;************************************************************************************

;; Converts an integer to a string
;;
;; The caller owns the buffer, so this answers with no pointer for
;; anyone to hold on to. That is what lets the same routine be both the kernel's
;; and the system call's, with no adapter in between
;;
;; Input:
;;
;; EAX - Integer
;; EDI - Caller's own buffer, at least 12 bytes
;;
;; Output:
;;
;; The number at EDI, NUL terminated. EDI preserved

;; What hexagonHandler used to guarantee before every one of these, and what
;; each has to guarantee for itself now that it is called and not trapped into:
;; ES agreeing with DS, since the moves inside write through ES:EDI and an
;; application's ES is whatever it was last left as, and a clear direction flag
;; both on the way in and on the way out, since two of the bodies set it and
;; never put it back
;;
;; ESI also comes back as it went in, the way the system-call entry in front of
;; it restored it: login reads its own trimmed string straight out of ESI

integetToString:

    push es

    push ds
    pop es

    cld

    push esi

    call .body

    pop esi

    cld ;; A body may have left it set

    pop es

    ret

.body:

    push es

    push ds ;; Kernel data segment
    pop es

    push eax
    push ecx
    push edx
    push esi
    push edi

;; Check if negative

    cmp eax, 0
    jge .positive

.negative:

    push eax

    mov byte[edi], '-' ;; Where the caller asked for the number, not the console

    inc edi

    pop eax

    neg eax

.positive:

;; Convert integer to string to be able to print

    mov ebx, 10  ;; Decimals are in base 10

    xor ecx, ecx ;; mov ECX, 0

.convertLoop:

    xor edx, edx ;; mov EDX, 0

    div ebx

    add dl, 0x30 ;; Convert to ASCII

    push edx

    inc ecx

    or eax, eax ;; cmp EAX, 0
    jne .convertLoop

    mov edx, 0
    mov ebx, edi ;; The caller's own buffer, still in EDI under the push above

.printLoop:

    pop eax

    mov byte[ebx + edx], al

    inc edx

    loop .printLoop

    mov byte[ebx + edx], 0

.end:

    pop edi
    pop esi
    pop edx
    pop ecx
    pop eax

    pop es

    ret
