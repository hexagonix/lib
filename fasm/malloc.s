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
;; Memory allocator for applications
;;
;; Compatibility: Hexagonix 1.1 or higher
;;                Hexagon 1.8.0 or newer (kernel version required)
;;                Version: 1.0 rev 0 13/09/2026
;;
;;************************************************************************************

;; The kernel hands out whole pages and keeps its own account of them, the way
;; brk and mmap do everywhere else; dividing a page up is this file's job, in
;; the process's own memory, the way malloc(3) does everywhere else.
;;
;; What that buys is one system call for every few dozen allocations instead of
;; one for each, and a block header that only its own process can reach: getting
;; it wrong costs that process and nobody else, where the kernel's arena is
;; shared with every other process and with the kernel itself.
;;
;; Chunks are never given back. A process that has grown keeps what it grew to
;; until it ends, and hx.exit hands all of it back at once. For a system whose
;; applications are mostly short lived that is the cheaper trade, and it is the
;; one thing here to revisit first if a long running one ever needs the space.

malloc.headerSize   = 8  ;; Size and stamp, in front of what the caller gets
malloc.minimumBlock = 16 ;; A free block also has to hold its two list pointers

malloc.blockSize     = 0
malloc.blockStamp    = 4
malloc.blockPrevious = 8  ;; Free blocks only
malloc.blockNext     = 12 ;; Free blocks only

;; A stamp and not a flag, so that a pointer that never came from here, or
;; one already given back, is refused instead of being followed into the list

malloc.used = 0A55A6000h
malloc.free = 0A55A6100h

malloc.firstChunk   = 4096  ;; What the first growth asks the kernel for
malloc.largestChunk = 65536 ;; Doubling stops here

;;************************************************************************************

;; Allocates memory for the calling application
;;
;; Input:
;;
;; EBX - Size wanted, in bytes
;;
;; Output:
;;
;; EAX - 0 if there was none to give
;; EBX - Pointer to the memory, if there was
;;
;; The same registers hx.malloc itself answers in, so a call here reads exactly
;; like the system call it replaces

malloc:

    push ecx
    push edx
    push esi
    push edi

    add ebx, malloc.headerSize + 3

    jc .withoutMemory ;; A request within a few bytes of 4 Gb, which wrapped

    and ebx, not 3

    cmp ebx, malloc.minimumBlock
    jae .search

    mov ebx, malloc.minimumBlock

.search:

    mov eax, dword[mallocState.firstFree]

.nextCandidate:

    cmp eax, 0
    je .grow

    cmp dword[eax + malloc.blockSize], ebx
    jae .blockFound

    mov eax, dword[eax + malloc.blockNext]

    jmp .nextCandidate

;; Nothing on hand is big enough, so ask the kernel for more and look again.
;; It comes back as one free block like any other

.grow:

    mov eax, dword[mallocState.chunkSize]

    cmp eax, ebx
    jae .chunkIsEnough

    mov eax, ebx ;; A single allocation larger than the usual chunk gets its own

.chunkIsEnough:

    push ebx ;; The rounded request, for the search this returns to

    mov ebx, eax

    push ebx ;; The chunk's own size, since hx.malloc answers in that register

    hx.syscall hx.malloc

    pop ecx

    cmp eax, 0
    je .growthFailed

    mov dword[ebx + malloc.blockSize], ecx
    mov dword[ebx + malloc.blockStamp], malloc.free

    call malloc.link

    mov eax, dword[mallocState.chunkSize]

    shl eax, 1

    cmp eax, malloc.largestChunk
    jbe .chunkSizeStored

    mov eax, malloc.largestChunk

.chunkSizeStored:

    mov dword[mallocState.chunkSize], eax

    pop ebx

    jmp .search

.growthFailed:

    pop ebx

    jmp .withoutMemory

;; ESI and EDI are this block's neighbours in the free list, and EDX becomes
;; whatever takes its place there: the remainder left by the split below, or
;; nothing at all when there is none left to describe

.blockFound:

    mov esi, dword[eax + malloc.blockPrevious]
    mov edi, dword[eax + malloc.blockNext]

    mov ecx, dword[eax + malloc.blockSize]

    sub ecx, ebx

    cmp ecx, malloc.minimumBlock
    jb .wholeBlock

    mov edx, eax

    add edx, ebx

    mov dword[edx + malloc.blockSize], ecx
    mov dword[edx + malloc.blockStamp], malloc.free
    mov dword[edx + malloc.blockPrevious], esi
    mov dword[edx + malloc.blockNext], edi

    mov dword[eax + malloc.blockSize], ebx

    jmp .unlink

.wholeBlock:

    xor edx, edx

.unlink:

    cmp esi, 0
    je .newHead

    cmp edx, 0
    je .previousToNext

    mov dword[esi + malloc.blockNext], edx

    jmp .repairNext

.previousToNext:

    mov dword[esi + malloc.blockNext], edi

    jmp .repairNext

.newHead:

    cmp edx, 0
    je .headToNext

    mov dword[mallocState.firstFree], edx

    jmp .repairNext

.headToNext:

    mov dword[mallocState.firstFree], edi

.repairNext:

    cmp edi, 0
    je .allocated

    cmp edx, 0
    je .nextToPrevious

    mov dword[edi + malloc.blockPrevious], edx

    jmp .allocated

.nextToPrevious:

    mov dword[edi + malloc.blockPrevious], esi

.allocated:

    mov dword[eax + malloc.blockStamp], malloc.used

    add eax, malloc.headerSize

    mov ebx, eax

    jmp .end

.withoutMemory:

    xor eax, eax

.end:

    pop edi
    pop esi
    pop edx
    pop ecx

    ret

;;************************************************************************************

;; Gives memory back
;;
;; Input:
;;
;; EBX - Pointer malloc returned
;; ECX - Ignored. The block's own header says how big it is, and the parameter
;;       stays only so a call here reads like the system call it replaces

free:

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    cmp ebx, 0
    je .end

    sub ebx, malloc.headerSize

;; Only a header malloc wrote carries the stamp. A pointer that never came from
;; there, or one already given back, is refused before a field of it is read

    cmp dword[ebx + malloc.blockStamp], malloc.used
    jne .end

    mov dword[ebx + malloc.blockStamp], malloc.free

    call malloc.link

.end:

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

;;************************************************************************************

;; Puts a block back in the free list, in address order, merged with whichever
;; of its neighbours are free. Shared by free and by malloc's own growth, which
;; has a fresh chunk to hand over and nothing else to do with it
;;
;; Input:
;;
;; EBX - The block, its size and stamp already written

malloc.link:

    push eax
    push esi
    push edi

;; Address order is what lets the two merges below look only at the immediate
;; neighbours. ESI ends up as the free block before this one and EDI as the
;; one after

    xor esi, esi

    mov edi, dword[mallocState.firstFree]

.locate:

    cmp edi, 0
    je .insert

    cmp edi, ebx
    ja .insert

    mov esi, edi
    mov edi, dword[edi + malloc.blockNext]

    jmp .locate

.insert:

    mov dword[ebx + malloc.blockPrevious], esi
    mov dword[ebx + malloc.blockNext], edi

    cmp esi, 0
    je .becomesHead

    mov dword[esi + malloc.blockNext], ebx

    jmp .linkNext

.becomesHead:

    mov dword[mallocState.firstFree], ebx

.linkNext:

    cmp edi, 0
    je .mergeBackward

    mov dword[edi + malloc.blockPrevious], ebx

;; Absorb the block that follows, when this one ends exactly where it starts.
;; Two chunks are separate allocations with the kernel's own bookkeeping in
;; between, so this never runs two of them together

    mov eax, ebx

    add eax, dword[ebx + malloc.blockSize]

    cmp eax, edi
    jne .mergeBackward

    mov eax, dword[edi + malloc.blockSize]

    add dword[ebx + malloc.blockSize], eax

    mov eax, dword[edi + malloc.blockNext]
    mov dword[ebx + malloc.blockNext], eax

    cmp eax, 0
    je .mergeBackward

    mov dword[eax + malloc.blockPrevious], ebx

;; And be absorbed by the one before, on the same test. Going forward first
;; means a block freed between two free ones comes out as one and not two

.mergeBackward:

    cmp esi, 0
    je .end

    mov eax, esi

    add eax, dword[esi + malloc.blockSize]

    cmp eax, ebx
    jne .end

    mov eax, dword[ebx + malloc.blockSize]

    add dword[esi + malloc.blockSize], eax

    mov eax, dword[ebx + malloc.blockNext]
    mov dword[esi + malloc.blockNext], eax

    cmp eax, 0
    je .end

    mov dword[eax + malloc.blockPrevious], esi

.end:

    pop edi
    pop esi
    pop eax

    ret

;;************************************************************************************

mallocState:

.firstFree: dd 0
.chunkSize: dd malloc.firstChunk
