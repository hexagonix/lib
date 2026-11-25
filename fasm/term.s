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
;; A terminal kept in memory as a grid of cells, for a program that plays one.
;; Bytes written to it are interpreted as the console terminal of Hexagon does.
;; Its memory comes from malloc.s
;;
;; Compatibility: Hexagonix 1.1 or higher
;;                Hexagon 1.9.0 or newer (kernel version required)
;;                Version: 1.0 rev 0 21/11/2026
;;
;;************************************************************************************

;; A terminal is Lib.Term.size bytes the caller provides. Its fields, for the
;; caller to read

Lib.Term.columns         = 0
Lib.Term.rows            = 4
Lib.Term.cells           = 8  ;; Row after row, Lib.Term.Cell.size bytes each
Lib.Term.dirty           = 12 ;; One byte per row, 1 once it changed. The caller clears it
Lib.Term.x               = 16 ;; Cursor, from 0. X may be one past the last column
Lib.Term.y               = 20
Lib.Term.savedX          = 24
Lib.Term.savedY          = 28
Lib.Term.font            = 32 ;; Colors written with, as 0RRGGBBh
Lib.Term.background      = 36
Lib.Term.themeFont       = 40 ;; Colors CSI 0 m goes back to
Lib.Term.themeBackground = 44
Lib.Term.state           = 48 ;; Byte, Lib.Term.States
Lib.Term.private         = 49 ;; Byte, the CSI had a private marker
Lib.Term.index           = 50 ;; Byte, parameter being read
Lib.Term.reverse         = 51 ;; Byte, colors swapped by CSI 7 m
Lib.Term.params          = 52 ;; Lib.Term.maxParams dwords
Lib.Term.size            = 72

Lib.Term.Cell.character  = 0
Lib.Term.Cell.font       = 4
Lib.Term.Cell.background = 8
Lib.Term.Cell.size       = 12

Lib.Term.maxParams = 5

Lib.Term.States.ground = 0
Lib.Term.States.escape = 1
Lib.Term.States.csi    = 2

;;************************************************************************************

;; Sets up a terminal, empty, with the cursor at the top left corner and every
;; row marked as changed
;;
;; Input:
;;
;; EDI - Terminal, Lib.Term.size bytes
;; EAX - Columns
;; EBX - Rows
;; ECX - Font color of the theme
;; EDX - Background color of the theme
;;
;; Output:
;;
;; CF set if there was no memory for it

if used termInit

termInit:

    pushad

    mov ebp, edi

    mov dword[ebp + Lib.Term.columns], eax
    mov dword[ebp + Lib.Term.rows], ebx
    mov dword[ebp + Lib.Term.themeFont], ecx
    mov dword[ebp + Lib.Term.themeBackground], edx
    mov dword[ebp + Lib.Term.font], ecx
    mov dword[ebp + Lib.Term.background], edx

    xor eax, eax

    mov dword[ebp + Lib.Term.x], eax
    mov dword[ebp + Lib.Term.y], eax
    mov dword[ebp + Lib.Term.savedX], eax
    mov dword[ebp + Lib.Term.savedY], eax
    mov dword[ebp + Lib.Term.cells], eax
    mov dword[ebp + Lib.Term.dirty], eax
    mov byte[ebp + Lib.Term.state], Lib.Term.States.ground
    mov byte[ebp + Lib.Term.reverse], 0

    mov eax, dword[ebp + Lib.Term.columns]

    mul dword[ebp + Lib.Term.rows]

    imul ebx, eax, Lib.Term.Cell.size

    call malloc

    cmp eax, 0

    je .noMemory

    mov dword[ebp + Lib.Term.cells], ebx

    mov ebx, dword[ebp + Lib.Term.rows]

    call malloc

    cmp eax, 0

    je .noMemory

    mov dword[ebp + Lib.Term.dirty], ebx

    mov ecx, dword[ebp + Lib.Term.rows]
    xor eax, eax

.clearRow:

    call Lib.Term.clearRow

    inc eax

    loop .clearRow

    popad

    clc

    ret

.noMemory:

    mov edi, ebp

    call termFree

    popad

    stc

    ret

end if

;;************************************************************************************

;; Gives back the memory of a terminal
;;
;; Input:
;;
;; EDI - Terminal

if used termFree | used termInit | used termResize

termFree:

    pushad

    mov ebx, dword[edi + Lib.Term.cells]

    cmp ebx, 0

    je .noCells

    call free

    mov dword[edi + Lib.Term.cells], 0

.noCells:

    mov ebx, dword[edi + Lib.Term.dirty]

    cmp ebx, 0

    je .done

    call free

    mov dword[edi + Lib.Term.dirty], 0

.done:

    popad

    ret

end if

;;************************************************************************************

;; Changes the size of a terminal. What fits stays where it was, and when the
;; cursor's row would fall out, the rows above it go first, so the line being
;; typed stays in view. Every row is marked as changed
;;
;; Input:
;;
;; EDI - Terminal
;; EAX - Columns
;; EBX - Rows
;;
;; Output:
;;
;; CF set if there was no memory, the terminal as it was

if used termResize

termResize:

    pushad
    push es

    push ds
    pop es

    mov ebp, edi

    mov [Lib.Term.Resize.columns], eax
    mov [Lib.Term.Resize.rows], ebx
    mov dword[Lib.Term.Resize.cells], 0

    mul ebx

    imul ebx, eax, Lib.Term.Cell.size

    call malloc

    cmp eax, 0

    je .noMemory

    mov [Lib.Term.Resize.cells], ebx

    mov ebx, [Lib.Term.Resize.rows]

    call malloc

    cmp eax, 0

    je .noMemory

    mov [Lib.Term.Resize.dirty], ebx

;; Every new cell blank first, in the colors being written with

    mov edi, [Lib.Term.Resize.cells]
    mov ecx, [Lib.Term.Resize.columns]
    imul ecx, [Lib.Term.Resize.rows]

    call Lib.Term.blankCells

;; Rows left out at the top, so the cursor's row fits

    xor eax, eax

    mov edx, dword[ebp + Lib.Term.y]

    cmp edx, [Lib.Term.Resize.rows]

    jb .shiftKnown

    mov eax, edx
    sub eax, [Lib.Term.Resize.rows]
    inc eax

.shiftKnown:

    mov [Lib.Term.Resize.shift], eax

;; Rows and columns both terminals have

    mov ecx, dword[ebp + Lib.Term.rows]
    sub ecx, eax

    cmp ecx, [Lib.Term.Resize.rows]

    jbe .rowsKnown

    mov ecx, [Lib.Term.Resize.rows]

.rowsKnown:

    mov edx, dword[ebp + Lib.Term.columns]

    cmp edx, [Lib.Term.Resize.columns]

    jbe .columnsKnown

    mov edx, [Lib.Term.Resize.columns]

.columnsKnown:

    imul edx, edx, Lib.Term.Cell.size ;; Bytes of each row copied

    xor ebx, ebx ;; Row of the new terminal

.copyRow:

    cmp ebx, ecx

    jae .copied

    push ecx

    mov eax, ebx
    add eax, [Lib.Term.Resize.shift]
    imul eax, dword[ebp + Lib.Term.columns]
    imul esi, eax, Lib.Term.Cell.size
    add esi, dword[ebp + Lib.Term.cells]

    mov eax, ebx
    imul eax, [Lib.Term.Resize.columns]
    imul edi, eax, Lib.Term.Cell.size
    add edi, [Lib.Term.Resize.cells]

    mov ecx, edx

    cld

    rep movsb

    pop ecx

    inc ebx

    jmp .copyRow

.copied:

    mov edi, ebp

    call termFree ;; The grid being replaced

    mov eax, [Lib.Term.Resize.columns]
    mov dword[ebp + Lib.Term.columns], eax

    mov eax, [Lib.Term.Resize.rows]
    mov dword[ebp + Lib.Term.rows], eax

    mov eax, [Lib.Term.Resize.cells]
    mov dword[ebp + Lib.Term.cells], eax

    mov eax, [Lib.Term.Resize.dirty]
    mov dword[ebp + Lib.Term.dirty], eax

;; The cursors, moved up with the rows and kept inside

    mov eax, [Lib.Term.Resize.shift]

    sub dword[ebp + Lib.Term.y], eax
    sub dword[ebp + Lib.Term.savedY], eax

    jns .savedInside

    mov dword[ebp + Lib.Term.savedY], 0

.savedInside:

    mov eax, [Lib.Term.Resize.rows]

    dec eax

    cmp dword[ebp + Lib.Term.savedY], eax

    jbe .savedRowFits

    mov dword[ebp + Lib.Term.savedY], eax

.savedRowFits:

    mov eax, [Lib.Term.Resize.columns]

    cmp dword[ebp + Lib.Term.x], eax

    jbe .xFits

    mov dword[ebp + Lib.Term.x], eax

.xFits:

    cmp dword[ebp + Lib.Term.savedX], eax

    jbe .savedXFits

    mov dword[ebp + Lib.Term.savedX], eax

.savedXFits:

    mov edi, dword[ebp + Lib.Term.dirty]
    mov ecx, [Lib.Term.Resize.rows]
    mov al, 1

    rep stosb

    pop es
    popad

    clc

    ret

.noMemory:

    mov ebx, [Lib.Term.Resize.cells]

    cmp ebx, 0

    je .nothingTaken

    call free

.nothingTaken:

    pop es
    popad

    stc

    ret

Lib.Term.Resize:

.columns: dd 0
.rows:    dd 0
.cells:   dd 0
.dirty:   dd 0
.shift:   dd 0

end if

;;************************************************************************************

;; Writes bytes to a terminal, as hx.write does to a VT. A sequence split
;; between two writes is still understood. Every register is preserved
;;
;; The cells are moved and filled through ES, so it is made to agree with DS
;; here, whatever the caller left in it
;;
;; Input:
;;
;; EDI - Terminal
;; ESI - Bytes
;; ECX - How many

if used termWrite | used termInit | used termResize

termWrite:

    pushad
    push es

    push ds
    pop es

    mov ebp, edi

    jecxz .done

.nextByte:

    mov al, byte[esi]

    call Lib.Term.putByte

    inc esi

    loop .nextByte

.done:

    pop es
    popad

    ret

;; The state machine of Hexagon.Kernel.Dev.Console.Terminal.putByte
;;
;; Input: AL - Byte, EBP - Terminal

Lib.Term.putByte:

    pushad

    cmp byte[ebp + Lib.Term.state], Lib.Term.States.escape

    je .escape

    cmp byte[ebp + Lib.Term.state], Lib.Term.States.csi

    je .csi

    cmp al, 27

    je .enterEscape

    cmp al, 13

    je .carriageReturn

    cmp al, 8

    je .backspace

    cmp al, 10

    je .newLine

    cmp al, 9

    je .space

    cmp al, ' '

    jb .end ;; Any other control character draws nothing

    cmp al, 7Fh

    je .end

    cmp al, '~'

    jbe .print

.space:

    mov al, ' ' ;; A tab, and a byte past ASCII, as the console draws them

.print:

    call Lib.Term.printCharacter

    jmp .end

.newLine:

    mov dword[ebp + Lib.Term.x], 0

    inc dword[ebp + Lib.Term.y]

    call Lib.Term.fitCursor

    jmp .end

.carriageReturn:

    mov dword[ebp + Lib.Term.x], 0

    jmp .end

.backspace:

    cmp dword[ebp + Lib.Term.x], 0

    je .end

    dec dword[ebp + Lib.Term.x]

    jmp .end

.enterEscape:

    mov byte[ebp + Lib.Term.state], Lib.Term.States.escape

    jmp .end

.escape:

    cmp al, '['

    je .enterCSI

    cmp al, '7'

    je .saveCursor

    cmp al, '8'

    je .restoreCursor

    cmp al, 20h

    jb .toGround

    cmp al, 2Fh

    jbe .end ;; Intermediate bytes wait for the final one

    jmp .toGround

.saveCursor:

    mov eax, dword[ebp + Lib.Term.x]
    mov dword[ebp + Lib.Term.savedX], eax
    mov eax, dword[ebp + Lib.Term.y]
    mov dword[ebp + Lib.Term.savedY], eax

    jmp .toGround

.restoreCursor:

    mov eax, dword[ebp + Lib.Term.savedX]
    mov dword[ebp + Lib.Term.x], eax
    mov eax, dword[ebp + Lib.Term.savedY]
    mov dword[ebp + Lib.Term.y], eax

    jmp .toGround

.enterCSI:

    mov byte[ebp + Lib.Term.state], Lib.Term.States.csi
    mov byte[ebp + Lib.Term.private], 0
    mov byte[ebp + Lib.Term.index], 0

    lea edi, [ebp + Lib.Term.params]
    mov ecx, Lib.Term.maxParams
    xor eax, eax

    cld

    rep stosd

    jmp .end

.csi:

    cmp al, '0'

    jb .notDigit

    cmp al, '9'

    ja .notDigit

    movzx ebx, byte[ebp + Lib.Term.index]

    cmp ebx, Lib.Term.maxParams

    jae .end

    sub al, '0'
    movzx eax, al

    mov ecx, dword[ebp + Lib.Term.params + ebx * 4]
    imul ecx, ecx, 10
    add ecx, eax

    cmp ecx, 0FFFFh

    jbe .storeParam

    mov ecx, 0FFFFh

.storeParam:

    mov dword[ebp + Lib.Term.params + ebx * 4], ecx

    jmp .end

.notDigit:

    cmp al, ';'

    jne .notSeparator

    cmp byte[ebp + Lib.Term.index], Lib.Term.maxParams

    jae .end

    inc byte[ebp + Lib.Term.index]

    jmp .end

.notSeparator:

    cmp al, '<'

    jb .notPrivate

    cmp al, '?'

    ja .notPrivate

    mov byte[ebp + Lib.Term.private], 1

    jmp .end

.notPrivate:

    cmp al, 40h

    jb .end ;; Intermediate bytes, ignored

    cmp al, 7Eh

    ja .toGround

    mov byte[ebp + Lib.Term.state], Lib.Term.States.ground

    cmp byte[ebp + Lib.Term.private], 0

    jne .end ;; Private sequences, such as CSI ? 25 l, are not supported

    call Lib.Term.execute

    jmp .end

.toGround:

    mov byte[ebp + Lib.Term.state], Lib.Term.States.ground

.end:

    popad

    ret

;;************************************************************************************

;; Writes a character at the cursor. Past the last column it goes to the next
;; line first, and past the last line the terminal scrolls, as the console does
;;
;; Input: AL - Character, EBP - Terminal

Lib.Term.printCharacter:

    pushad

    mov ecx, dword[ebp + Lib.Term.columns]

    cmp dword[ebp + Lib.Term.x], ecx

    jb .fits

    mov dword[ebp + Lib.Term.x], 0

    inc dword[ebp + Lib.Term.y]

.fits:

    call Lib.Term.fitCursor

    push eax

    mov eax, dword[ebp + Lib.Term.x]
    mov ebx, dword[ebp + Lib.Term.y]

    call Lib.Term.cellAddress

    pop eax

    mov byte[edi + Lib.Term.Cell.character], al

    mov eax, dword[ebp + Lib.Term.font]
    mov dword[edi + Lib.Term.Cell.font], eax

    mov eax, dword[ebp + Lib.Term.background]
    mov dword[edi + Lib.Term.Cell.background], eax

    call Lib.Term.markRow

    inc dword[ebp + Lib.Term.x]

    popad

    ret

;; Scrolls when the cursor went past the last line, leaving it at the start of
;; the last one
;;
;; Input: EBP - Terminal

Lib.Term.fitCursor:

    pushad

    mov ecx, dword[ebp + Lib.Term.rows]

    cmp dword[ebp + Lib.Term.y], ecx

    jb .done

    call Lib.Term.scroll

    dec ecx

    mov dword[ebp + Lib.Term.y], ecx
    mov dword[ebp + Lib.Term.x], 0

.done:

    popad

    ret

;; Every row moves up one, and the last one is cleared
;;
;; Input: EBP - Terminal

Lib.Term.scroll:

    pushad

    mov eax, dword[ebp + Lib.Term.columns]

    imul eax, eax, Lib.Term.Cell.size ;; Bytes of a row

    mov edi, dword[ebp + Lib.Term.cells]
    lea esi, [edi + eax]

    mov ecx, dword[ebp + Lib.Term.rows]

    dec ecx

    imul ecx, eax

    cld

    rep movsb

    mov eax, dword[ebp + Lib.Term.rows]

    dec eax

    call Lib.Term.clearRow

    mov edi, dword[ebp + Lib.Term.dirty]
    mov ecx, dword[ebp + Lib.Term.rows]
    mov al, 1

    rep stosb

    popad

    ret

;;************************************************************************************

;; Runs a complete CSI sequence
;;
;; Input: AL - Final byte, EBP - Terminal

Lib.Term.execute:

    cmp al, 'A'

    jb .end

    cmp al, 'D'

    jbe Lib.Term.moveCursor

    cmp al, 'G'

    je Lib.Term.setColumn

    cmp al, 'H'

    je Lib.Term.setCursor

    cmp al, 'f'

    je Lib.Term.setCursor

    cmp al, 'J'

    je Lib.Term.eraseScreen

    cmp al, 'K'

    je Lib.Term.eraseLine

    cmp al, 'm'

    je Lib.Term.setGraphics

.end:

    ret

;; Input: EBX - Parameter index, EBP - Terminal. Output: EAX - Its value, 0 when empty

Lib.Term.param:

    xor eax, eax

    cmp bl, byte[ebp + Lib.Term.index]

    ja .end

    cmp ebx, Lib.Term.maxParams

    jae .end

    mov eax, dword[ebp + Lib.Term.params + ebx * 4]

.end:

    ret

;; CSI n A/B/C/D, stopping at the edges

Lib.Term.moveCursor:

    mov cl, al

    xor ebx, ebx

    call Lib.Term.param

    cmp eax, 0

    jne .haveCount

    inc eax

.haveCount:

    mov esi, dword[ebp + Lib.Term.x]
    mov edi, dword[ebp + Lib.Term.y]

    cmp cl, 'A'

    je .up

    cmp cl, 'B'

    je .down

    cmp cl, 'C'

    je .forward

    sub esi, eax

    jmp Lib.Term.clampAndPosition

.up:

    sub edi, eax

    jmp Lib.Term.clampAndPosition

.down:

    add edi, eax

    jmp Lib.Term.clampAndPosition

.forward:

    add esi, eax

    jmp Lib.Term.clampAndPosition

;; CSI row ; column H, both from 1

Lib.Term.setCursor:

    xor ebx, ebx

    call Lib.Term.param

    mov edi, eax

    inc ebx

    call Lib.Term.param

    mov esi, eax

    cmp edi, 0

    je .rowGiven

    dec edi

.rowGiven:

    cmp esi, 0

    je .columnGiven

    dec esi

.columnGiven:

    jmp Lib.Term.clampAndPosition

;; CSI n G, from 1, on the row the cursor is on

Lib.Term.setColumn:

    xor ebx, ebx

    call Lib.Term.param

    mov esi, eax

    cmp esi, 0

    je .columnGiven

    dec esi

.columnGiven:

    mov edi, dword[ebp + Lib.Term.y]

;; Input: ESI - Column, EDI - Row, both signed

Lib.Term.clampAndPosition:

    cmp esi, 0

    jge .columnNotNegative

    xor esi, esi

.columnNotNegative:

    mov eax, dword[ebp + Lib.Term.columns]

    dec eax

    cmp esi, eax

    jle .columnInside

    mov esi, eax

.columnInside:

    cmp edi, 0

    jge .rowNotNegative

    xor edi, edi

.rowNotNegative:

    mov eax, dword[ebp + Lib.Term.rows]

    dec eax

    cmp edi, eax

    jle .rowInside

    mov edi, eax

.rowInside:

    mov dword[ebp + Lib.Term.x], esi
    mov dword[ebp + Lib.Term.y], edi

    ret

;; CSI J clears from the cursor to the end, CSI 2 J and 3 J everything. CSI 1 J
;; does nothing, as on the console. The cursor stays

Lib.Term.eraseScreen:

    xor ebx, ebx

    call Lib.Term.param

    cmp eax, 0

    je .toEnd

    cmp eax, 2

    jb .done

    mov ecx, dword[ebp + Lib.Term.rows]
    xor eax, eax

.clearAll:

    call Lib.Term.clearRow

    inc eax

    loop .clearAll

    jmp .done

.toEnd:

    call Lib.Term.clearInLine ;; EAX is 0, to the end of the line

    mov eax, dword[ebp + Lib.Term.y]

.nextRow:

    inc eax

    cmp eax, dword[ebp + Lib.Term.rows]

    jae .done

    call Lib.Term.clearRow

    jmp .nextRow

.done:

    ret

;; CSI K, 1 K and 2 K. The cursor stays

Lib.Term.eraseLine:

    xor ebx, ebx

    call Lib.Term.param

    cmp eax, 2

    je .wholeLine

    ja .done

    call Lib.Term.clearInLine

    jmp .done

.wholeLine:

    mov eax, dword[ebp + Lib.Term.y]

    call Lib.Term.clearRow

.done:

    ret

;; Spaces in the colors being written with, over part of the cursor's row. One
;; past the last column counts as the last one
;;
;; Input: EAX - 0 from the cursor to the end, 1 from the start to the cursor

Lib.Term.clearInLine:

    pushad

    mov edx, dword[ebp + Lib.Term.x]
    mov ecx, dword[ebp + Lib.Term.columns]

    dec ecx ;; Last column

    cmp edx, ecx

    jbe .inside

    mov edx, ecx

.inside:

    cmp eax, 0

    je .fromCursor

    mov ecx, edx ;; From 0 to the cursor
    xor edx, edx

    jmp .clear

.fromCursor:

    sub ecx, edx ;; From the cursor to the last column

.clear:

    inc ecx

    mov eax, edx
    mov ebx, dword[ebp + Lib.Term.y]

    call Lib.Term.cellAddress

    call Lib.Term.blankCells

    call Lib.Term.markRow

    popad

    ret

;; Input: EAX - Row, EBP - Terminal

Lib.Term.clearRow:

    pushad

    mov ebx, eax
    xor eax, eax

    call Lib.Term.cellAddress

    mov ecx, dword[ebp + Lib.Term.columns]

    call Lib.Term.blankCells

    call Lib.Term.markRow

    popad

    ret

;; Input: EDI - First cell, ECX - How many, EBP - Terminal

Lib.Term.blankCells:

    pushad

    mov eax, dword[ebp + Lib.Term.font]
    mov edx, dword[ebp + Lib.Term.background]

.cell:

    mov byte[edi + Lib.Term.Cell.character], ' '
    mov dword[edi + Lib.Term.Cell.font], eax
    mov dword[edi + Lib.Term.Cell.background], edx

    add edi, Lib.Term.Cell.size

    loop .cell

    popad

    ret

;; Input: EAX - Column, EBX - Row, EBP - Terminal. Output: EDI - The cell

Lib.Term.cellAddress:

    push eax
    push edx

    push eax

    mov eax, ebx

    mul dword[ebp + Lib.Term.columns]

    pop edx

    add eax, edx

    imul edi, eax, Lib.Term.Cell.size

    add edi, dword[ebp + Lib.Term.cells]

    pop edx
    pop eax

    ret

;; Input: EBX - Row, EBP - Terminal

Lib.Term.markRow:

    push edi

    mov edi, dword[ebp + Lib.Term.dirty]

    mov byte[edi + ebx], 1

    pop edi

    ret

;;************************************************************************************

;; CSI ... m. Colors apply to whatever is written next

Lib.Term.setGraphics:

    mov esi, dword[ebp + Lib.Term.font]
    mov edi, dword[ebp + Lib.Term.background]

    xor ebx, ebx

.nextParam:

    cmp bl, byte[ebp + Lib.Term.index]

    ja .apply

    cmp ebx, Lib.Term.maxParams

    jae .apply

    call Lib.Term.param

    cmp eax, 0

    je .reset

    cmp eax, 7

    je .reverse

    cmp eax, 27

    je .notReverse

    cmp eax, 38

    je .directForeground

    cmp eax, 48

    je .directBackground

    cmp eax, 39

    je .themeForeground

    cmp eax, 49

    je .themeBackground

    cmp eax, 30

    jb .next

    cmp eax, 37

    jbe .foreground

    cmp eax, 40

    jb .next

    cmp eax, 47

    jbe .background

    cmp eax, 90

    jb .next

    cmp eax, 97

    jbe .brightForeground

    cmp eax, 100

    jb .next

    cmp eax, 107

    jbe .brightBackground

    jmp .next

.reset:

    mov esi, dword[ebp + Lib.Term.themeFont]
    mov edi, dword[ebp + Lib.Term.themeBackground]

    mov byte[ebp + Lib.Term.reverse], 0

    jmp .next

.reverse:

    cmp byte[ebp + Lib.Term.reverse], 0

    jne .next

    mov byte[ebp + Lib.Term.reverse], 1

    xchg esi, edi

    jmp .next

.notReverse:

    cmp byte[ebp + Lib.Term.reverse], 0

    je .next

    mov byte[ebp + Lib.Term.reverse], 0

    xchg esi, edi

    jmp .next

.themeForeground:

    mov esi, dword[ebp + Lib.Term.themeFont]

    jmp .next

.themeBackground:

    mov edi, dword[ebp + Lib.Term.themeBackground]

    jmp .next

.foreground:

    mov esi, dword[Lib.Term.palette + eax * 4 - 30 * 4]

    jmp .next

.background:

    mov edi, dword[Lib.Term.palette + eax * 4 - 40 * 4]

    jmp .next

.brightForeground:

    mov esi, dword[Lib.Term.palette + eax * 4 - 82 * 4]

    jmp .next

.brightBackground:

    mov edi, dword[Lib.Term.palette + eax * 4 - 92 * 4]

    jmp .next

.directForeground:

    call Lib.Term.directColor

    jc .apply

    mov esi, eax

    jmp .next

.directBackground:

    call Lib.Term.directColor

    jc .apply

    mov edi, eax

.next:

    inc ebx

    jmp .nextParam

.apply:

    mov dword[ebp + Lib.Term.font], esi
    mov dword[ebp + Lib.Term.background], edi

    ret

;; Reads the 2;r;g;b after a 38 or 48
;;
;; Input: EBX - Index of the 38 or 48
;;
;; Output: EAX - Color, EBX - Index of the last parameter used, CF set if what
;; follows is not 2;r;g;b, which ends the sequence

Lib.Term.directColor:

    push ecx

    add ebx, 4

    cmp bl, byte[ebp + Lib.Term.index]

    ja .invalid

    sub ebx, 3

    call Lib.Term.param

    cmp eax, 2

    jne .invalid

    xor ecx, ecx

    inc ebx

    call Lib.Term.param

    mov cl, al
    shl ecx, 8

    inc ebx

    call Lib.Term.param

    mov cl, al
    shl ecx, 8

    inc ebx

    call Lib.Term.param

    mov cl, al

    mov eax, ecx

    pop ecx

    clc

    ret

.invalid:

    pop ecx

    stc

    ret

;; The 16 colors of CSI 30-37, 90-97 and their backgrounds, as on the console

Lib.Term.palette:

dd 0x000000, 0xAA0000, 0x00AA00, 0xAA5500, 0x0000AA, 0xAA00AA, 0x00AAAA, 0xAAAAAA
dd 0x555555, 0xFF5555, 0x55FF55, 0xFFFF55, 0x5555FF, 0xFF55FF, 0x55FFFF, 0xFFFFFF

end if
