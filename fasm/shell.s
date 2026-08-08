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
;; Shared routines for Hexagonix's shells (sh, hash, ash, dossh): PATH
;; lookup, the "set" builtin, /etc/shrc parsing and script/shebang
;; dispatch. Every shell including this file is expected to already
;; declare its own "appFileBuffer" label, the same scratch buffer
;; convention each of them already uses for hx.open
;;
;; Compatibility: Hexagonix Mineru or higher
;;                Hexagon 1.7.0 or newer (kernel version required)
;;                Version: 1.0 rev 0 07/08/2026
;;
;;************************************************************************************

;; Resolves a command name against PATH if it can't be found as given
;;
;; Input:
;;
;; ESI - Command name, as typed
;;
;; Output:
;;
;; ESI - Path to use for hx.exec/hx.spawn: unchanged if the name already
;;       contains '/' or already exists as given, otherwise the first
;;       PATH entry it's found under; left unchanged if not found there
;;       either (so the caller's usual "not found" handling still applies)

Shell.resolveCommandPath:

    push eax
    push ebx
    push edi

    mov [Shell.resolveCommandPath.original], esi

    mov edi, esi

.checkSlash:

    mov al, byte[edi]

    cmp al, 0
    je .tryAsGiven

    cmp al, '/'
    je .useOriginal ;; Explicit path, don't touch it

    inc edi

    jmp .checkSlash

.tryAsGiven:

    hx.syscall hx.fileExists

    jnc .useOriginal ;; Found relative to the current directory

    mov esi, Shell.resolveCommandPath.pathName

    hx.syscall hx.getenv

    jc .useOriginal ;; No PATH defined

    mov [Shell.resolveCommandPath.cursor], esi

.tryNextDir:

    mov esi, dword[Shell.resolveCommandPath.cursor]

    cmp byte[esi], 0
    je .useOriginal ;; Ran out of PATH entries

    mov edi, Shell.resolveCommandPath.candidate

.copyDir:

    mov al, byte[esi]

    cmp al, 0
    je .dirCopied

    cmp al, ':'
    je .dirCopied

    mov byte[edi], al

    inc esi
    inc edi

    jmp .copyDir

.dirCopied:

    cmp byte[esi], ':'
    jne .noSeparator

    inc esi

.noSeparator:

    mov [Shell.resolveCommandPath.cursor], esi

;; Only insert a separator if this PATH entry didn't already end with one.
;; PATH=/ (the system default) already ends in '/', and joining it with
;; another '/' before the command name produced "//name" instead of "/name"

    cmp edi, Shell.resolveCommandPath.candidate
    je .needSlash

    cmp byte[edi - 1], '/'
    je .noSlash

.needSlash:

    mov byte[edi], '/'

    inc edi

.noSlash:

    push edi

    mov esi, dword[Shell.resolveCommandPath.original]

.copyName:

    mov al, byte[esi]

    mov byte[edi], al

    inc esi
    inc edi

    cmp al, 0
    jne .copyName

    pop edi

    mov esi, Shell.resolveCommandPath.candidate

    hx.syscall hx.fileExists

    jc .tryNextDir

;; Found: ESI is already Shell.resolveCommandPath.candidate

    jmp .end

.useOriginal:

    mov esi, dword[Shell.resolveCommandPath.original]

.end:

    pop edi
    pop ebx
    pop eax

    ret

Shell.resolveCommandPath.original:  dd 0
Shell.resolveCommandPath.cursor:    dd 0
Shell.resolveCommandPath.pathName:  db "PATH", 0
Shell.resolveCommandPath.candidate: times 64 db 0

;;************************************************************************************

;; Implements the "set" builtin: no arguments lists every variable
;; ("set"), "set NAME=VALUE" defines one
;;
;; Input:
;;
;; ESI - Everything typed after "set ", already trimmed

Shell.handleSet:

    push eax
    push esi
    push edi

    cmp byte[esi], 0
    je .listAll

    mov edi, esi

.findEquals:

    mov al, byte[edi]

    cmp al, 0
    je .listAll ;; No '=': not a valid assignment, list instead

    cmp al, '='
    je .foundEquals

    inc edi

    jmp .findEquals

.foundEquals:

    mov byte[edi], 0 ;; Split NAME\0VALUE in place

    inc edi

    hx.syscall hx.setenv ;; ESI = name, EDI = value

    jmp .end

.listAll:

    putNewLine

    hx.syscall hx.environ

.dumpLoop:

    cmp byte[esi], 0
    je .end

    printString
    putNewLine

.skipEntry:

    cmp byte[esi], 0
    je .skipped

    inc esi

    jmp .skipEntry

.skipped:

    inc esi

    jmp .dumpLoop

.end:

    pop edi
    pop esi
    pop eax

    ret

;;************************************************************************************

;; Reads /etc/shrc at startup, into the including shell's own
;; "appFileBuffer". A line shaped like NAME=VALUE becomes hx.setenv;
;; anything else is just printed, the same plain banner text /etc/shrc
;; has always had

Shell.loadRc:

    push eax
    push esi
    push edi

    mov esi, Shell.loadRc.path
    mov edi, appFileBuffer

    xor ecx, ecx

    hx.syscall hx.open

    jc .end ;; No /etc/shrc, nothing to do

    mov esi, appFileBuffer

.lineLoop:

    cmp byte[esi], 0
    je .end

    mov [Shell.loadRc.lineStart], esi
    mov dword[Shell.loadRc.equalsPos], 0

    mov edi, esi

.scanLine:

    mov al, byte[edi]

    cmp al, 0
    je .lineEnd

    cmp al, 10
    je .lineEnd

    cmp al, '='
    jne .notEquals

    cmp dword[Shell.loadRc.equalsPos], 0
    jne .notEquals ;; Only remember the first '=' on this line

    mov [Shell.loadRc.equalsPos], edi

.notEquals:

    inc edi

    jmp .scanLine

.lineEnd:

    mov [Shell.loadRc.terminatorPos], edi

    mov al, byte[edi]
    mov [Shell.loadRc.terminatorChar], al

    mov byte[edi], 0 ;; Cut the buffer here so this line stands alone

    cmp dword[Shell.loadRc.equalsPos], 0
    je .printLine

;; NAME=VALUE line

    mov edi, dword[Shell.loadRc.equalsPos]

    mov byte[edi], 0 ;; Split NAME\0VALUE

    inc edi

    mov esi, dword[Shell.loadRc.lineStart]

    hx.syscall hx.setenv

    jmp .nextLine

.printLine:

    mov esi, dword[Shell.loadRc.lineStart]

    printString
    putNewLine

.nextLine:

    mov edi, dword[Shell.loadRc.terminatorPos]

    mov al, byte[Shell.loadRc.terminatorChar]

    mov byte[edi], al ;; Restore, in case the line is ever scanned again

    cmp al, 0
    je .end

    mov esi, edi

    inc esi

    jmp .lineLoop

.end:

    pop edi
    pop esi
    pop eax

    ret

Shell.loadRc.path:           db "/etc/shrc", 0
Shell.loadRc.lineStart:      dd 0
Shell.loadRc.equalsPos:      dd 0
Shell.loadRc.terminatorPos:  dd 0
Shell.loadRc.terminatorChar: dd 0

;;************************************************************************************

;; Looks at a file's first line for a "#!name" shebang
;;
;; Input:
;;
;; ESI - Path of an existing file to check
;;
;; Output:
;;
;; ESI - Shell name found after "#!", if any
;; CF - Set if the file doesn't start with "#!" (ESI undefined)

Shell.checkShebang:

    push eax
    push edi
    push ecx

;; appFileBuffer has no reserved space of its own, it relies on whatever
;; free slack happens to sit past this shell's own compiled image, per the
;; convention documented alongside Hexagon.Kern.Proc.allocateAndLoadImage.
;; A shebang line only ever needs the first handful of bytes, so cap the
;; read well under that slack instead of pulling in the resolved command's
;; entire file. For a large executable (fasmX, ~110 KB, being the one that
;; actually exposed this) hx.open's old unconditional full read overflowed
;; straight past this process's own allocated block and crashed the VM,
;; every time, before hx.exec was ever reached

    mov edi, appFileBuffer

    mov ecx, 512

    hx.syscall hx.open

    pop ecx

    jc .notShebang

    mov esi, appFileBuffer

    cmp byte[esi], '#'
    jne .notShebang

    cmp byte[esi + 1], '!'
    jne .notShebang

    add esi, 2

    mov [Shell.checkShebang.nameStart], esi

    mov edi, esi

.findEnd:

    mov al, byte[edi]

    cmp al, 0
    je .terminate

    cmp al, 10
    je .terminate

    cmp al, 13
    je .terminate

    inc edi

    jmp .findEnd

.terminate:

    mov byte[edi], 0

    mov esi, dword[Shell.checkShebang.nameStart]

    cmp byte[esi], 0
    je .notShebang ;; "#!" with nothing after it

    clc

    jmp .end

.notShebang:

    stc

.end:

    pop edi
    pop eax

    ret

Shell.checkShebang.nameStart: dd 0

;;************************************************************************************

;; Copies a command's argument string to a private buffer before
;; Shell.checkShebang runs. Shell.checkShebang opens the resolved
;; command's own file into the caller's shared appFileBuffer to look at
;; its first line, which is also where the caller's getArguments-style
;; split already stashed the typed arguments, so calling it between
;; splitting the arguments and actually using them would silently
;; replace those arguments with the command's own file content instead
;;
;; Input:
;;
;; EDI - Argument string to protect, or 0 if there are none
;;
;; Output:
;;
;; EDI - Pointer to the protected copy, or 0 if the input was 0

Shell.protectArguments:

    push esi
    push eax

    cmp edi, 0
    je .end

    mov esi, edi
    mov edi, Shell.protectArguments.buffer

.copyLoop:

    mov al, byte[esi]
    mov byte[edi], al

    inc esi
    inc edi

    cmp al, 0
    jne .copyLoop

    mov edi, Shell.protectArguments.buffer

.end:

    pop eax
    pop esi

    ret

Shell.protectArguments.buffer:
times 512 db 0

;;************************************************************************************

;; Runs a file as a batch of shell commands, one per line. Blank lines
;; and lines starting with '#' (including a "#!" shebang line) are
;; skipped. Each command is resolved via Shell.resolveCommandPath and
;; run with hx.exec (blocking, foreground), same as typing it
;; interactively
;;
;; Input:
;;
;; ESI - Path of the script file to run

Shell.runScriptFile:

    push eax
    push esi
    push edi

    mov edi, appFileBuffer

    xor ecx, ecx

    hx.syscall hx.open

    jc .end ;; Script not found, nothing to run

    mov esi, appFileBuffer

.lineLoop:

    cmp byte[esi], 0
    je .end

    cmp byte[esi], 10
    je .emptyLine

    cmp byte[esi], '#'
    je .emptyLine

;; Find where this line truly ends before touching anything

    mov edi, esi

.findRealEnd:

    mov al, byte[edi]

    cmp al, 0
    je .gotRealEnd

    cmp al, 10
    je .gotRealEnd

    inc edi

    jmp .findRealEnd

.gotRealEnd:

    mov [Shell.runScriptFile.lineEnd], edi

    mov al, byte[edi]
    mov [Shell.runScriptFile.savedChar], al

    mov byte[edi], 0 ;; Cut the buffer here so this line stands alone

;; Split command name from arguments at the first space, if any

    mov edi, esi

.findSpace:

    mov al, byte[edi]

    cmp al, 0
    je .noArgs

    cmp al, ' '
    je .hasArgs

    inc edi

    jmp .findSpace

.hasArgs:

    mov byte[edi], 0

    inc edi

    mov [Shell.runScriptFile.argsPtr], edi
    mov dword[Shell.runScriptFile.hasArgsFlag], 1

    jmp .resolveAndExec

.noArgs:

    mov dword[Shell.runScriptFile.argsPtr], 0
    mov dword[Shell.runScriptFile.hasArgsFlag], 0

.resolveAndExec:

    push esi

    call Shell.resolveCommandPath

    mov edi, dword[Shell.runScriptFile.argsPtr]
    mov eax, dword[Shell.runScriptFile.hasArgsFlag]

    hx.syscall hx.exec

    pop esi

    jmp .restoreAndNext

.emptyLine:

    mov edi, esi

.findLineEnd:

    mov al, byte[edi]

    cmp al, 0
    je .end

    cmp al, 10
    je .emptyLineDone

    inc edi

    jmp .findLineEnd

.emptyLineDone:

    mov esi, edi

    inc esi

    jmp .lineLoop

.restoreAndNext:

    mov edi, dword[Shell.runScriptFile.lineEnd]

    mov al, byte[Shell.runScriptFile.savedChar]
    mov byte[edi], al

    cmp al, 0
    je .end

    mov esi, edi

    inc esi

    jmp .lineLoop

.end:

    pop edi
    pop esi
    pop eax

    ret

Shell.runScriptFile.lineEnd:     dd 0
Shell.runScriptFile.savedChar:   dd 0
Shell.runScriptFile.argsPtr:     dd 0
Shell.runScriptFile.hasArgsFlag: dd 0

;; End of this file
