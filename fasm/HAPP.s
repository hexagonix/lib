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
;; Macros for creating and manipulating HAPP headers and images
;;
;; Compatibility: Hexagonix 1.1 or higher
;;                Hexagon 1.8.0 or newer (kernel version required)
;;                Version: 2.0 rev 1 13/09/2026
;;
;;************************************************************************************

;; Bytes of zeroed space the image wants past its own end, for buffers it
;; declares but emits no bytes for. Zero cannot mean "none": every image built
;; before this field existed carries zero there and depends on the margin the
;; kernel handed out regardless, so zero goes on meaning exactly that margin.
;; An image that wants nothing says so with HAPP.bss.none

;; What an image asks for when it wants nothing past its own end, which is the
;; same as leaving the parameter out. Saying it has a point anyway: it
;; marks an image as one that has been looked at and reads through the
;; allocator, and not one nobody has got to yet

HAPP.bss.none = 0

;; What an image that still reads a file into a bare label past its own end
;; needs. Each one drops to HAPP.bss.none as it moves to asking the allocator
;; for room instead, so grepping for this name is what is left to do

HAPP.bss.trailingBuffer = 65536 ;; 64 Kb

macro headerHAPP imageArchitecture, minVersion, minMinorVersion, entryPointHAPP, imageTypeHAPP, bssSizeHAPP
{

;; HAPP2 specification (HAPP 2.0 rev 1)

HAPP.image.signature:    db "HAPP"
HAPP.image.architecture: db imageArchitecture
HAPP.image.minVer:       db minVersion
HAPP.image.minMinorVer:  db minMinorVersion
HAPP.image.entryPoint:   dd entryPointHAPP
HAPP.image.imageType:    db imageTypeHAPP

;; Zeroed space the image wants past its own end, as described above

HAPP.image.bssSize:

if bssSizeHAPP eq

dd 0 ;; Written without saying, and so given nothing

else

dd bssSizeHAPP

end if

HAPP.image.reserved1:    db 0 ;; Reserved (Byte)
HAPP.image.reserved2:    db 0 ;; Reserved (Byte)
HAPP.image.reserved3:    db 0 ;; Reserved (Byte)
HAPP.image.reserved4:    dd 0 ;; Reserved (Dword)
HAPP.image.reserved5:    dd 0 ;; Reserved (Dword)
HAPP.image.reserved6:    dd 0 ;; Reserved (Dword)
HAPP.image.reserved7:    db 0 ;; Reserved (Byte)
HAPP.image.reserved8:    dw 0 ;; Reserved (Word)
HAPP.image.reserved9:    dw 0 ;; Reserved (Word)
HAPP.image.reserved10:   dw 0 ;; Reserved (Word)

}

HAPP.Architectures:

.i386  = 01h ;; Default
.amd64 = 02h

;; Others, one day

HAPP.imageType: ;; HAPP image types that can be declared in the header

.exec      = 01h
.lib       = 02h ;; For libraries (still being implemented)
.dlib      = 03h ;; Future use (dynamically loaded libraries)
.reserved  = 04h ;; This image stores data, is not executable