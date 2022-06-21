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
;;
;;************************************************************************************
;;
;; Lista de dispositivos que podem ser acessados pelo usuário
;;
;; Compatibilidade:   Sistema Operacional Hexagonix®/Andromeda® 1.14.4 (12/12/2020) ou superior
;; Versão:            1.0 rev 1 12/12/2020
;; Autor:             Felipe Miguel Nery Lunkes
;;
;;************************************************************************************

;; Erros de entrada e saída (I/O)

IO:

.escritaNegada   equ 1
.leituraNegada   equ 2 
.erroLeitura     equ 3
.erroEscrita     equ 4
.operacaoNegada  equ 5

Hexagon:

.imagemAusente   equ 1
.erroCarregando  equ 2
.limiteProcessos equ 3
.imagemInvalida  equ 4
