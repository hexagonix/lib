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
;;                         Copyright (c) 2015-2024 Felipe Miguel Nery Lunkes
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
;; Copyright (c) 2015-2024, Felipe Miguel Nery Lunkes
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
;; Compatibility: Hexagonix H1 System I or higher
;;                Hexagon 1.0.1 or newer (kernel version required)
;;                Version: 7.0 rev 1 01/05/2024
;;
;; Total calls: 68 (04/26/2020) - This number is not final and may decrease (or increase)
;;
;;************************************************************************************

;;************************************************************************************
;;
;; Table 1: Hexagon System Calls
;;
;;************************************************************************************

hx.malloc                 = 1  ;; Hexagon memory and process management services
hx.free                   = 2  ;; Hexagon memory and process management services
hx.exec                   = 3  ;; Hexagon memory and process management services
hx.exit                   = 4  ;; Hexagon memory and process management services
hx.pid                    = 5  ;; Hexagon memory and process management services
hx.memoryUsage            = 6  ;; Hexagon memory and process management services
hx.getProcesses           = 7  ;; Hexagon memory and process management services
hx.getErrorCode           = 8  ;; Hexagon memory and process management services
hx.open                   = 9  ;; Hexagon File and Device Management Services
hx.write                  = 10 ;; Hexagon File and Device Management Services
hx.close                  = 11 ;; Hexagon File and Device Management Services
hx.create                 = 13 ;; Hexagon File System and Volume Management Services
hx.unlink                 = 14 ;; Hexagon File System and Volume Management Services
hx.rename                 = 15 ;; Hexagon File System and Volume Management Services
hx.listFiles              = 16 ;; Hexagon File System and Volume Management Services
hx.fileExists             = 17 ;; Hexagon File System and Volume Management Services
hx.getVolume              = 18 ;; Hexagon File System and Volume Management Services
hx.lock                   = 19 ;; Hexagon User Management Services
hx.unlock                 = 20 ;; Hexagon User Management Services
hx.setUser                = 21 ;; Hexagon User Management Services
hx.getUser                = 22 ;; Hexagon User Management Services
hx.uname                  = 23 ;; Services offered by Hexagon
hx.getRandom              = 24 ;; Services offered by Hexagon
hx.feedRandom             = 25 ;; Services offered by Hexagon
hx.sleep                  = 26 ;; Services offered by Hexagon
hx.installISR             = 27 ;; Services offered by Hexagon
hx.restart                = 28 ;; Hexagon Power Management Services
hx.shutdown               = 29 ;; Hexagon Power Management Services
hx.print                  = 30 ;; Hexagon Graphics and Video Output Services
hx.clearConsole           = 31 ;; Hexagon Graphics and Video Output Services
hx.clearLine              = 32 ;; Hexagon Graphics and Video Output Services
hx.scrollConsole          = 33 ;; Hexagon Graphics and Video Output Services
hx.setCursor              = 34 ;; Hexagon Graphics and Video Output Services
hx.drawCharacter          = 35 ;; Hexagon Graphics and Video Output Services
hx.drawBlock              = 36 ;; Hexagon Graphics and Video Output Services
hx.printCharacter         = 37 ;; Hexagon Graphics and Video Output Services
hx.setColor               = 38 ;; Hexagon Graphics and Video Output Services
hx.getColor               = 39 ;; Hexagon Graphics and Video Output Services
hx.getConsoleInfo         = 40 ;; Hexagon Graphics and Video Output Services
hx.updateScreen           = 41 ;; Hexagon Graphics and Video Output Services
hx.setResolution          = 42 ;; Hexagon Graphics and Video Output Services
hx.getResolution          = 43 ;; Hexagon Graphics and Video Output Services
hx.getCursor              = 44 ;; Hexagon Graphics and Video Output Services
hx.waitKeyboard           = 45 ;; Hexagon PS/2 Keyboard Handling Services
hx.getString              = 46 ;; Hexagon PS/2 Keyboard Handling Services
hx.getKeyState            = 47 ;; Hexagon PS/2 Keyboard Handling Services
hx.changeConsoleFont      = 48 ;; Hexagon PS/2 Keyboard Handling Services
hx.changeLayout           = 49 ;; Hexagon PS/2 Keyboard Handling Services
hx.waitMouse              = 50 ;; Hexagon PS/2 Mouse Handling Services
hx.getMouse               = 51 ;; Hexagon PS/2 Mouse Handling Services
hx.setMouse               = 52 ;; Hexagon PS/2 Mouse Handling Services
hx.compareWordsString     = 53 ;; Hexagon data manipulation and conversion services
hx.removeCharacterString  = 54 ;; Hexagon data manipulation and conversion services
hx.insertCharacter        = 55 ;; Hexagon data manipulation and conversion services
hx.stringSize             = 56 ;; Hexagon data manipulation and conversion services
hx.compareString          = 57 ;; Hexagon data manipulation and conversion services
hx.stringToUppercase      = 58 ;; Hexagon data manipulation and conversion services
hx.stringToLowercase      = 59 ;; Hexagon data manipulation and conversion services
hx.trimString             = 60 ;; Hexagon data manipulation and conversion services
hx.findCharacter          = 61 ;; Hexagon data manipulation and conversion services
hx.stringToInt            = 62 ;; Hexagon data manipulation and conversion services
hx.toString               = 63 ;; Hexagon data manipulation and conversion services
hx.emitSound              = 64 ;; Hexagon Sound Output Services
hx.turnOffSound           = 65 ;; Hexagon Sound Output Services
hx.sendMessageHexagon     = 66 ;; Hexagon Messaging Services
hx.date                   = 67 ;; Hexagon Real Time Clock Service
hx.time                   = 68 ;; Hexagon Real Time Clock Service

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

    int 69h

}

;; End of file
