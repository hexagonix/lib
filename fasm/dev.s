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
;; List of devices that can be accessed by the user
;;
;; Compatibility: Hexagonix System I or higher
;;                Hexagon 1.01 or newer (kernel version required)
;;                Version: 1.0.2 rev 4 29/08/2025
;;
;;************************************************************************************

Hexagon.LibASM.Dev.disks:

;; Storage devices

.hd0: ;; First hard drive
db "hd0", 0
.hd1: ;; Second hard drive
db "hd1", 0
.hd2: ;; Third hard drive
db "hd2", 0
.hd3: ;; Fourth hard drive
db "hd3", 0
.dsq0: ;; Floppy disk 1
db "dsq0", 0
.dsq1: ;; Floppy disk 2
db "dsq1", 0
.cdrom: ;; First CD drive
db "cdrom0", 0

Hexagon.LibASM.Dev.serialPorts:

;; Serial ports

.com1: ;; First serial port
db "com1", 0
.com2: ;; Second serial port
db "com2", 0
.com3: ;; Third serial port
db "com3", 0
.com4: ;; Fourth serial port
db "com4", 0

Hexagon.LibASM.Dev.parallelPorts:

;; Parallel ports

.lpt0: ;; First parallel port
db "lpt0", 0
.lpt1: ;; Second parallel port
db "lpt1", 0
.lpt2: ;; Third parallel port
db "lpt2", 0

Hexagon.LibASM.Dev.video:

;; Output devices

.tty0: ;; Default console
db "tty0", 0
.tty1: ;; First virtual console
db "tty1", 0
.tty2: ;; Kernel data dump Console
db "tty2", 0

Hexagon.LibASM.Dev.audio:

.au0: ;; Audio output
db "au0", 0

Hexagon.LibASM.Dev.processors:

.proc0: ;; First processor
db "proc0", 0
.proc1: ;; Auxiliary processor, if any
db "proc1", 0
