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
;; The terminal of the process, descriptor 0, and line editing over it
;;
;; Compatibility: Hexagonix 1.1 or higher
;;                Hexagon 1.8.0 or newer (kernel version required)
;;                Version: 1.0 rev 0 20/10/2026
;;
;;************************************************************************************

;; Mode bits of a tty, as hx.ioctl commands 4 and 5 take them

Lib.TTY.Modes.canonical = 01h ;; Whole lines, edited by the kernel
Lib.TTY.Modes.echo      = 02h ;; Typed bytes shown
Lib.TTY.Modes.isig      = 04h ;; Ctrl+C ends what runs on the terminal

;; EAX - Mode of the terminal

macro ttyGetMode
{

    mov eax, 0
    mov ebx, 4

    hx.syscall hx.ioctl

}

macro ttySetMode mode
{

    mov ecx, mode
    mov eax, 0
    mov ebx, 5

    hx.syscall hx.ioctl

}

;;************************************************************************************

;; Reads a line from the terminal, with insertion anywhere in it, Backspace,
;; Delete, Home, End and the arrows. Only bytes and escape sequences are used,
;; so it works on any terminal. Ctrl+C drops the line, as the shells of BSD do
;; at their prompt, and reads as an empty one. Every register is preserved
;;
;; Input:
;;
;; AL  - Maximum length of the line
;; EBX - 1234h to show nothing of what is typed
;; EDI - Buffer, room for that length plus a terminator
;;
;; Output:
;;
;; The line at EDI, NUL terminated

if used readLine

readLine:

    pushad

    mov byte[Lib.TTY.maxLength], al
    mov dword[Lib.TTY.echo], ebx
    mov dword[Lib.TTY.buffer], edi

    mov byte[edi], 0
    mov byte[Lib.TTY.length], 0
    mov byte[Lib.TTY.position], 0
    mov byte[Lib.TTY.shown], 0

    ttyGetMode

    mov dword[Lib.TTY.savedMode], eax

    ttySetMode 0 ;; Every key as it comes, and nothing shown by the kernel

;; Shows the cursor where the line starts, taking it away from wherever it
;; was drawn before

    mov esi, Lib.TTY.showCursor
    mov ecx, Lib.TTY.showCursor.size

    call Lib.TTY.write

    call .redraw

.nextKey:

    call .readByte

    cmp al, 10

    je .done

    cmp al, 8

    je .backspace

    cmp al, 27

    je .escape

    cmp al, 03h ;; Ctrl+C

    je .interrupt

.plainByte:

    cmp al, ' '

    jb .edited

    cmp al, '~'

    ja .edited

    mov cl, byte[Lib.TTY.length]

    cmp cl, byte[Lib.TTY.maxLength]

    jae .edited

;; Opens a place for it at the position, terminator included

    mov edi, dword[Lib.TTY.buffer]
    movzx ecx, byte[Lib.TTY.length]
    movzx edx, byte[Lib.TTY.position]

.shiftRight:

    mov bl, byte[edi + ecx]
    mov byte[edi + ecx + 1], bl

    cmp ecx, edx

    je .insert

    dec ecx

    jmp .shiftRight

.insert:

    mov byte[edi + edx], al

    inc byte[Lib.TTY.length]
    inc byte[Lib.TTY.position]

    jmp .edited

.backspace:

    cmp byte[Lib.TTY.position], 0

    je .edited

    dec byte[Lib.TTY.position]

    call .removeAtPosition

    jmp .edited

.escape:

    call .readByte

    cmp al, '['

    jne .plainByte ;; A lone Esc, the byte after it is a key of its own

    call .readByte

    cmp al, 'C'

    je .right

    cmp al, 'D'

    je .left

    cmp al, 'H'

    je .home

    cmp al, 'F'

    je .end

    cmp al, '3'

    jne .edited

    call .readByte ;; The ~ of ESC [ 3 ~

    mov cl, byte[Lib.TTY.position]

    cmp cl, byte[Lib.TTY.length]

    je .edited

    call .removeAtPosition

    jmp .edited

.right:

    mov cl, byte[Lib.TTY.position]

    cmp cl, byte[Lib.TTY.length]

    je .edited

    inc byte[Lib.TTY.position]

    jmp .edited

.left:

    cmp byte[Lib.TTY.position], 0

    je .edited

    dec byte[Lib.TTY.position]

    jmp .edited

.home:

    mov byte[Lib.TTY.position], 0

    jmp .edited

.end:

    mov cl, byte[Lib.TTY.length]
    mov byte[Lib.TTY.position], cl

.edited:

    call .redraw

    jmp .nextKey

.interrupt:

    mov cl, byte[Lib.TTY.length]
    mov byte[Lib.TTY.position], cl

    call .redraw ;; The cursor goes past the end of the line

    mov esi, Lib.TTY.interrupted
    mov ecx, 2

    call Lib.TTY.write

    mov edi, dword[Lib.TTY.buffer]
    mov byte[edi], 0

.done:

    mov eax, dword[Lib.TTY.savedMode]

    ttySetMode eax

    popad

    clc

    ret

;; Takes the byte at the position out of the line, terminator included

.removeAtPosition:

    mov edi, dword[Lib.TTY.buffer]
    movzx ecx, byte[Lib.TTY.position]

.shiftLeft:

    mov bl, byte[edi + ecx + 1]
    mov byte[edi + ecx], bl

    inc ecx

    cmp bl, 0

    jne .shiftLeft

    dec byte[Lib.TTY.length]

    ret

;; Writes the line again from its start, followed by a space for a byte just
;; taken out, and leaves the cursor at the position

.redraw:

    cmp dword[Lib.TTY.echo], 1234h

    je .noRedraw

    movzx eax, byte[Lib.TTY.shown]

    call Lib.TTY.moveBack

    mov esi, dword[Lib.TTY.buffer]
    movzx ecx, byte[Lib.TTY.length]

    call Lib.TTY.write

    mov esi, Lib.TTY.space
    mov ecx, 1

    call Lib.TTY.write

    movzx eax, byte[Lib.TTY.length]
    movzx ecx, byte[Lib.TTY.position]
    sub eax, ecx
    inc eax

    call Lib.TTY.moveBack

    mov al, byte[Lib.TTY.position]
    mov byte[Lib.TTY.shown], al

.noRedraw:

    ret

.readByte:

    mov eax, 0
    mov edi, Lib.TTY.key
    mov ecx, 1

    hx.syscall hx.read

    mov al, byte[Lib.TTY.key]

    ret

end if

;;************************************************************************************

;; Writes ESI, ECX bytes long, to the terminal

if used Lib.TTY.write

Lib.TTY.write:

    pushad

    mov eax, 1

    hx.syscall hx.write

    popad

    ret

end if

;;************************************************************************************

;; Moves the cursor back EAX columns, nothing for 0

if used Lib.TTY.moveBack

Lib.TTY.moveBack:

    pushad

    cmp eax, 0

    je .done

    mov edi, Lib.TTY.sequence

    mov byte[edi], 27
    mov byte[edi + 1], '['

    add edi, 2

    mov ecx, 10

    push 0FFh ;; Marks where the digits end

.divide:

    xor edx, edx

    div ecx

    push edx

    cmp eax, 0

    jne .divide

.store:

    pop edx

    cmp edx, 0FFh

    je .letter

    add dl, '0'

    mov byte[edi], dl

    inc edi

    jmp .store

.letter:

    mov byte[edi], 'D'

    inc edi

    mov esi, Lib.TTY.sequence
    mov ecx, edi
    sub ecx, esi

    call Lib.TTY.write

.done:

    popad

    ret

end if

;;************************************************************************************

Lib.TTY:

.maxLength: db 0
.length:    db 0
.position:  db 0
.shown:     db 0 ;; Position the cursor was left at by the last redraw
.echo:      dd 0
.buffer:    dd 0
.savedMode: dd 0
.key:       dd 0
.space:     db ' '
.sequence:  times 16 db 0

.showCursor: db 27, "[C", 27, "[D"
.showCursor.size = $ - .showCursor

.interrupted: db "^C"
