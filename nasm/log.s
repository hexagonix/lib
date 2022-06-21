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
;; Lista de prioridades para mensagens do Sistema
;;
;; Compatibilidade:   Sistema Operacional Hexagonix®/Andromeda® 1.11 (09/06/2019) ou superior
;; Versão:            1.0 rev 09/06/2019
;; Autor:             Felipe Miguel Nery Lunkes
;;
;;************************************************************************************

;; Lista de prioridades do Kernel:
;;
;; 0 - Interromper a execução do processo atual e exibir uma mensagem (a ser implementado).
;; 1 - Não interromper o processamento e exibir a mensagem apenas, interrompendo a execução de
;;     qualquer processo (a ser implementado).
;; 2 - Exibir a mensagem apenas de algum utilitário realizar uma chamada de solicitação
;;     (a ser implementado).
;; 3 - Mensagem relevante apenas ao Kernel (a ser implementado).
;; 4 - Enviar a mensagem apenas via serial, para fins de debug (verbose).
;; 5 - Enviar a mensagem na saída padrão e por via serial (padrão).

Log.Prioridades:

.p0 equ 0
.p1 equ 1
.p2 equ 2
.p3 equ 3
.p4 equ 4
.p5 equ 5
.pa equ 10

;; Um macro simples para enviar mensagens para o log do Sistema

%macro logSistema 3

    mov esi, [%1]   ;; Mensagem a ser enviada
    mov eax, [%2] ;; Código de erro
    mov ebx, [%3] ;; Importante!

    Hexagonix enviarMensagemHexagon

%endmacro
