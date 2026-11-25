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
;; Hexagon sysctl
;;
;; Compatibility: Hexagonix 1.1 or higher
;;                Hexagon 1.10.0 or newer (kernel version required)
;;                Version: 1.1.0 27/11/2026
;;
;;************************************************************************************

;; A single extensible entry point for reading/writing kernel-maintained
;;
;; Input:
;;
;; EBX selects the function:
;;     - 1 reads the kernel's own log buffer
;;     - 2 reads the ticks of the processor since boot, as kern.cp_time in BSD
;;     - 3 reads the memory in pages, as vm.stats in BSD
;;     - 4 reads the blocks of memory of the process EDX names, as KERN_PROC_VMMAP

hx.sysctl.getKernelLog     = 1
hx.sysctl.getCPUTime       = 2
hx.sysctl.getVMStats       = 3
hx.sysctl.getProcessBlocks = 4

;; What function 2 writes, in dwords. A share of the processor is the change
;; in a count between two readings over the change in the three together

hx.sysctl.cpuTime.frequency = 0  ;; Ticks a second
hx.sysctl.cpuTime.user      = 4  ;; In the code of processes
hx.sysctl.cpuTime.system    = 8  ;; In the kernel
hx.sysctl.cpuTime.idle      = 12 ;; With nothing to do
hx.sysctl.cpuTime.size      = 16

;; What function 3 writes, in dwords. What the kernel holds is wired, as
;; nothing of it can be given away

hx.sysctl.vmStats.pageSize     = 0  ;; Bytes in a page
hx.sysctl.vmStats.total        = 4  ;; Pages in all
hx.sysctl.vmStats.free         = 8
hx.sysctl.vmStats.wiredStatic  = 12 ;; Held by the kernel from boot
hx.sysctl.vmStats.wiredDynamic = 16 ;; Taken by the kernel since, for itself or a process
hx.sysctl.vmStats.processes    = 20
hx.sysctl.vmStats.size         = 24

;; What function 4 writes: the size of a record in a dword, then a record for
;; each block. With the buffer too small, EAX is the size needed and CF is set,
;; and CF with EAX at 0 means there is no such process

hx.sysctl.block.address = 0 ;; In physical memory
hx.sysctl.block.size    = 4 ;; Header included
hx.sysctl.block.kind    = 8 ;; One of hx.sysctl.blockKinds below

hx.sysctl.blockKinds.image       = 1 ;; Code, data and stack
hx.sysctl.blockKinds.paging      = 2 ;; Tables that map it and its kernel stack
hx.sysctl.blockKinds.arguments   = 3
hx.sysctl.blockKinds.environment = 4
hx.sysctl.blockKinds.heap        = 5 ;; Taken through hx.malloc

