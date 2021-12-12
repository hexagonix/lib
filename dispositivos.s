;;************************************************************************************
;;
;;    
;;        %#@$%&@$%&@$%$             Sistema Operacional Andromeda®
;;        #$@$@$@#@#@#@$
;;        @#@$%    %#$#%
;;        @#$@$    #@#$@
;;        #@#$$    !@#@#     Copyright © 2016-2021 Felipe Miguel Nery Lunkes
;;        @#@%!$&%$&$#@#             Todos os direitos reservados
;;        !@$%#%&#&@&$%#
;;        @$#!%&@&@#&*@&
;;        $#$#%    &%$#@       Lista de dispositivos acessíveis ao usuário
;;        @#!$$    !#@#@
;;
;;
;;************************************************************************************
;;
;; Lista de dispositivos que podem ser acessados pelo usuário
;;
;; Compatibilidade:   Sistema Operacional Andromeda® 1.7 (26/11/2017) ou superior
;; Versão:            1.0 rev 2 17/12/2020
;; Autor:             Felipe Miguel Nery Lunkes
;;
;;************************************************************************************

discos:

;; Dispositivos de armazenamento

.hd0:   db "hd0", 0   ;; Primeiro disco rígido
.hd1:   db "hd1", 0   ;; Segundo disco rígido
.hd2:   db "hd2", 0   ;; Terceiro disco rígido
.hd3:   db "hd3", 0   ;; Quarto disco rígido
.dsq0:  db "dsq0", 0  ;; Disquete 1
.dsq1:  db "dsq1", 0  ;; Disquete 2
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

.vd0: db "vd0", 0 ;; Dispositivo de saída padrão
.vd1: db "vd1", 0 ;; Dispositivo de saída secundário em memória (Buffer)
.vd2: db "vd2", 0 ;; Despejo de dados do Kernel

audio:

.au0: db "au0", 0 ;; Saída de áudio

processadores:

.proc0: db "proc0", 0 ;; Primeiro processador
.proc1: db "proc1", 0 ;; Processador auxiliar, caso exista
