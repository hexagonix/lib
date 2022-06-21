;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2022 Felipe Miguel Nery Lunkes
;; │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘          Todos os direitos reservados
;; ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
;; └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
;;              ┌─┘│          
;;              └──┘          
;;
;;************************************************************************************
;;
;; Compatibilidade:   Sistema Operacional Hexagonix®/Andromeda® 1.14.3 (24/11/2020) ou superior
;;                    Hexagon® 8.40 ou superior
;; Versão:            1.0 rev 1 02/10/2021
;; Autor:             Felipe Miguel Nery Lunkes
;;
;;************************************************************************************

%macro cabecalhoHAPP 5

;; Especificação HAPP2 (HAPP 2.0 rev 0)

assinatura:      db "HAPP"
arquitetura:     db [%1]
versaoMinima:    db [%2]
subVersaoMinima: db [%3]
pontoEntrada:    dd [%4]
tipoImagemHAPP:  db [%5]
reservado0:      dd 0      ;; Reservado (Dword)
reservado1:      db 0      ;; Reservado (Byte)
reservado2:      db 0      ;; Reservado (Byte)
reservado3:      db 0      ;; Reservado (Byte)
reservado4:      dd 0      ;; Reservado (Dword)
reservado5:      dd 0      ;; Reservado (Dword)
reservado6:      dd 0      ;; Reservado (Dword)
reservado7:      db 0      ;; Reservado (Byte)
reservado8:      dw 0      ;; Reservado (Word)
reservado9:      dw 0      ;; Reservado (Word)
reservado10:     dw 0      ;; Reservado (Word)

%endmacro

HAPP.Arquiteturas:

.i386  equ 01h ;; Padrão
.amd64 equ 02h

;; Outras, um dia

HAPP.tipoImagem: ;; Tipos de imagem HAPP que podem ser declaradas no cabeçalho

.exec      equ 01h
.lib       equ 02h ;; Para bibliotecas (ainda em implementação)
.dlib      equ 03h ;; Uso futuro (bibliotecas dinamicamente carregadas)
.reservado equ 04h ;; Essa imagem armazena dados, não é executável