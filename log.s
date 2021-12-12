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
;; Lista de prioridades para mensagens do Sistema
;;
;; Compatibilidade:   Sistema Operacional Andromeda® 1.11 (09/06/2019) ou superior
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

;; Um macro simples para enviar mensagens para o log do Sistema

macro logSistema mensagem, codigoErro, prioridade
{

    mov esi, mensagem   ;; Mensagem a ser enviada
    mov eax, codigoErro ;; Código de erro
    mov ebx, prioridade ;; Importante!

    Andromeda enviarMensagemHexagon

}
