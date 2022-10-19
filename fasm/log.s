;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2022 Felipe Miguel Nery Lunkes
;; │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘          Todos os direitos reservados
;; ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
;; └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
;;              ┌─┘│                 Licenciado sob licença BSD-3-Clause
;;              └──┘          
;;
;;
;;************************************************************************************
;;
;; Este arquivo é licenciado sob licença BSD-3-Clause. Observe o arquivo de licença 
;; disponível no repositório para mais informações sobre seus direitos e deveres ao 
;; utilizar qualquer trecho deste arquivo.
;;
;; Copyright (C) 2016-2022 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.

;;************************************************************************************
;;
;; Lista de prioridades para mensagens do Sistema
;;
;; Compatibilidade:   Sistema Operacional Hexagonix® 1.11 (09/06/2019) ou superior
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

.p0 = 0
.p1 = 1
.p2 = 2
.p3 = 3
.p4 = 4
.p5 = 5
.pa = 10
.syslogd: db "syslogd.app", 0

;; Um macro simples para enviar mensagens para o log do Sistema

macro logSistema mensagem, codigoErro, prioridade
{

    mov esi, mensagem   ;; Mensagem a ser enviada
    mov eax, codigoErro ;; Código de erro
    mov ebx, prioridade ;; Importante!

    Hexagonix enviarMensagemHexagon

}

;; Syslogd deverá ser o mecanismo padrão para envio de mensagens de log quando
;; possível, por utilitários do sistema que não são críticos (como exemplo de 
;; utilitários críticos, temos init, login, energia, etc). Os utilitários 
;; de ambiente Andromeda deverão usar preferencialmente o syslogd, para evitar
;; acesso direto a interfaces expostas pelo Hexagon, impedindo também o mau
;; uso da interface, uma vez que as mensagens são tratadas previamente pelo syslogd.
;; Para utilitários críticos envolvidos diretamente na inicialização e manutenção do
;; sistema, o acesso direto ainda pode ser executado, uma vez que o nível de prioridade
;; pode mudar de acordo com a aplicação. 

macro syslogdX mensagem, codigoErro, prioridade
{

    mov esi, Log.Prioridades.syslogd
    mov edi, mensagem
    mov eax, 01h ;; Não deixar em branco

    Hexagonix iniciarProcesso

}