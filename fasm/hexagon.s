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
;; Header of Hexagonix Macros, Functions and System Calls
;;
;; Compatibility: Hexagonix 1.1 or higher
;;                Hexagon 1.8.0 or newer (kernel version required)
;;                Version: 9.1.0 13/09/2026
;;
;; Total calls: 70 (at 13/09/2026)
;;
;;************************************************************************************

;;************************************************************************************
;;
;; Table 1: Hexagon System Calls
;;
;; Grouped by service, matching Hexagon/kern/systab.asm's table exactly (each
;; group here is the same block of numbers as the matching comment there)
;;
;;************************************************************************************

;; Memory and process management

hx.malloc                 = 1  ;; Hexagon memory and process management services
hx.free                   = 2  ;; Hexagon memory and process management services
hx.exec                   = 3  ;; Hexagon memory and process management services
hx.exit                   = 4  ;; Hexagon memory and process management services
hx.pid                    = 5  ;; Hexagon memory and process management services
hx.spawn                  = 6  ;; Hexagon memory and process management services
hx.kill                   = 7  ;; Hexagon memory and process management services
hx.memoryUsage            = 8  ;; Hexagon memory and process management services
hx.getProcesses           = 9  ;; Hexagon memory and process management services
hx.getErrorCode           = 10 ;; Hexagon memory and process management services
hx.getenv                 = 11 ;; Hexagon memory and process management services
hx.setenv                 = 12 ;; Hexagon memory and process management services
hx.unsetenv               = 13 ;; Hexagon memory and process management services
hx.environ                = 14 ;; Hexagon memory and process management services

;; File and device management

hx.open                   = 15 ;; Hexagon File and Device Management Services
hx.write                  = 16 ;; Hexagon File and Device Management Services
hx.close                  = 17 ;; Hexagon File and Device Management Services

;; Filesystem and volume management

hx.create                 = 18 ;; Hexagon File System and Volume Management Services
hx.touch                  = 19 ;; Hexagon File System and Volume Management Services
hx.unlink                 = 20 ;; Hexagon File System and Volume Management Services
hx.rename                 = 21 ;; Hexagon File System and Volume Management Services
hx.listFiles              = 22 ;; Hexagon File System and Volume Management Services
hx.stat                   = 23 ;; Hexagon File System and Volume Management Services
hx.mkdir                  = 24 ;; Hexagon File System and Volume Management Services
hx.rmdir                  = 25 ;; Hexagon File System and Volume Management Services
hx.changeDirectory        = 26 ;; Hexagon File System and Volume Management Services
hx.getCurrentDirectory    = 27 ;; Hexagon File System and Volume Management Services
hx.mount                  = 28 ;; Hexagon File System and Volume Management Services
hx.unmount                = 29 ;; Hexagon File System and Volume Management Services
hx.getMounts              = 30 ;; Hexagon File System and Volume Management Services

;; User management

hx.lock                   = 31 ;; Hexagon User Management Services
hx.unlock                 = 32 ;; Hexagon User Management Services
hx.setUser                = 33 ;; Hexagon User Management Services
hx.getUser                = 34 ;; Hexagon User Management Services

;; Services offered by Hexagon

hx.uname                  = 35 ;; Services offered by Hexagon
hx.sleep                  = 36 ;; Services offered by Hexagon
hx.installISR             = 37 ;; Services offered by Hexagon

;; Hexagon Power Management Services

hx.restart                = 38 ;; Hexagon Power Management Services
hx.shutdown               = 39 ;; Hexagon Power Management Services

;; Hexagon Graphics and Video Output Services

hx.print                  = 40 ;; Hexagon Graphics and Video Output Services
hx.clearConsole           = 41 ;; Hexagon Graphics and Video Output Services
hx.clearLine              = 42 ;; Hexagon Graphics and Video Output Services
hx.scrollConsole          = 43 ;; Hexagon Graphics and Video Output Services
hx.setCursor              = 44 ;; Hexagon Graphics and Video Output Services
hx.drawCharacter          = 45 ;; Hexagon Graphics and Video Output Services
hx.drawBlock              = 46 ;; Hexagon Graphics and Video Output Services
hx.printCharacter         = 47 ;; Hexagon Graphics and Video Output Services
hx.setColor               = 48 ;; Hexagon Graphics and Video Output Services
hx.getColor               = 49 ;; Hexagon Graphics and Video Output Services
hx.getConsoleInfo         = 50 ;; Hexagon Graphics and Video Output Services
hx.updateScreen           = 51 ;; Hexagon Graphics and Video Output Services
hx.getResolution          = 52 ;; Hexagon Graphics and Video Output Services
hx.getCursor              = 53 ;; Hexagon Graphics and Video Output Services

;; Hexagon PS/2 Keyboard Handling Services

hx.waitKeyboard           = 54 ;; Hexagon PS/2 Keyboard Handling Services
hx.getString              = 55 ;; Hexagon PS/2 Keyboard Handling Services
hx.getKeyState            = 56 ;; Hexagon PS/2 Keyboard Handling Services
hx.changeConsoleFont      = 57 ;; Hexagon PS/2 Keyboard Handling Services
hx.changeLayout           = 58 ;; Hexagon PS/2 Keyboard Handling Services

;; Hexagon PS/2 Mouse Handling Services

hx.waitMouse              = 59 ;; Hexagon PS/2 Mouse Handling Services
hx.getMouse               = 60 ;; Hexagon PS/2 Mouse Handling Services
hx.setMouse               = 61 ;; Hexagon PS/2 Mouse Handling Services

;; Hexagon data manipulation and conversion services


;; Hexagon Sound Output Services

hx.emitSound              = 62 ;; Hexagon Sound Output Services
hx.turnOffSound           = 63 ;; Hexagon Sound Output Services

;; Hexagon Messaging Services

hx.sendMessageHexagon     = 64 ;; Hexagon Messaging Services

;; Hexagon Real Time Clock Service

hx.date                   = 65 ;; Hexagon Real Time Clock Service
hx.time                   = 66 ;; Hexagon Real Time Clock Service

;; Hexagon Device Control Service

hx.ioctl                  = 67 ;; Hexagon Device Control Service

;; Hexagon File System and Volume Management Services

hx.chown                  = 68 ;; Hexagon File System and Volume Management Services

;; Hexagon Process Management Service

hx.getTTY                 = 69 ;; Hexagon Process Management Service
hx.sysctl                 = 70 ;; Hexagon Kernel Diagnostics Service

;;************************************************************************************

;;************************************************************************************
;;
;;                                    libasm
;;                                    Macros
;;
;;************************************************************************************

macro hx.syscall syscallHexagon ;; Macro used to request a service from Hexagon
{

    push syscallHexagon

    int 80h

}

;; End of file
