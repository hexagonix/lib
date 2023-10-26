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
;;                         Copyright (c) 2015-2023 Felipe Miguel Nery Lunkes
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
;; Copyright (c) 2015-2023, Felipe Miguel Nery Lunkes
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
;; Lista de dispositivos que podem ser acessados pelo usuário
;;
;; Compatibilidade: Hexagonix H1 ou superior
;;                  Hexagon 1.0.1 ou mais recente (versão do kernel necessária)
;; Versão:          1.0.1 rev 3 26/10/2023
;;
;;************************************************************************************

discos:

;; Dispositivos de armazenamento

.hd0: ;; Primeiro disco rígido
db "hd0", 0    
.hd1: ;; Segundo disco rígido
db "hd1", 0    
.hd2: ;; Terceiro disco rígido
db "hd2", 0    
.hd3: ;; Quarto disco rígido
db "hd3", 0    
.dsq0: ;; Disquete 1
db "dsq0", 0   
.dsq1: ;; Disquete 2
db "dsq1", 0   
.cdrom: ;; Primeiro drive de CD
db "cdrom0", 0 

portasSeriais:

;; Portas seriais

.com1: ;; Primeira porta serial
db "com1", 0 
.com2: ;; Segunda porta serial
db "com2", 0 
.com3: ;; Terceira porta serial
db "com3", 0
.com4: ;; Quarta porta serial
db "com4", 0 

portasParalelas:

;; Portas paralelas e impressoras

.imp0: ;; Primeira porta paralela
db "imp0", 0 
.imp1: ;; Segunda porta paralela
db "imp1", 0 
.imp2: ;; Terceira porta paralela
db "imp2", 0

video:

;; Dispositivos de saída

.tty0: ;; Console principal
db "tty0", 0 
.tty1: ;; Primeiro console virtual
db "tty1", 0 
.tty2: ;; Console de despejo de dados do kernel
db "tty2", 0 

audio:

.au0: ;; Saída de áudio
db "au0", 0 

processadores:

.proc0: ;; Primeiro processador
db "proc0", 0 
.proc1: ;; Processador auxiliar, caso exista
db "proc1", 0 
