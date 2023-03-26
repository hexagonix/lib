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
;;                    Sistema Operacional Hexagonix® - Hexagonix® Operating System
;;
;;                          Copyright © 2015-2023 Felipe Miguel Nery Lunkes
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
;; Compatibilidade:   Sistema Operacional Hexagonix® H1 ou superior
;; Versão:            1.0 rev 3 18/01/2023
;; Autor:             Felipe Miguel Nery Lunkes
;;
;;************************************************************************************

discos:

;; Dispositivos de armazenamento

.hd0:   db "hd0", 0    ;; Primeiro disco rígido
.hd1:   db "hd1", 0    ;; Segundo disco rígido
.hd2:   db "hd2", 0    ;; Terceiro disco rígido
.hd3:   db "hd3", 0    ;; Quarto disco rígido
.dsq0:  db "dsq0", 0   ;; Disquete 1
.dsq1:  db "dsq1", 0   ;; Disquete 2
.cdrom: db "cdrom0", 0 ;; Primeiro drive de CD

portasSeriais:

;; Portas seriais

.com1: db "com1", 0 ;; Primeira porta serial
.com2: db "com2", 0 ;; Segunda porta serial
.com3: db "com3", 0 ;; Terceira porta serial
.com4: db "com4", 0 ;; Quarta porta serial

portasParalelas:

;; Portas paralelas e impressoras

.imp0: db "imp0", 0 ;; Primeira porta paralela
.imp1: db "imp1", 0 ;; Segunda porta paralela
.imp2: db "imp2", 0 ;; Terceira porta paralela

video:

;; Dispositivos de saída

.vd0: db "vd0", 0 ;; Console padrão
.vd1: db "vd1", 0 ;; Primeiro console virtual
.vd2: db "vd2", 0 ;; Despejo de dados do Kernel

audio:

.au0: db "au0", 0 ;; Saída de áudio

processadores:

.proc0: db "proc0", 0 ;; Primeiro processador
.proc1: db "proc1", 0 ;; Processador auxiliar, caso exista
