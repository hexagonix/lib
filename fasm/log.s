;;************************************************************************************
;;
;;                             ┌┐ ┌┐
;;                             ││ ││
;;                             │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐
;;                             │┌─┐││─┼┼┼┤┌┐│┌┐│┌┐│┌┐┼┼┼┼┘
;;                             ││ │││─┼┼┼┤┌┐│└┘│└┘││││├┼┼┐
;;                             └┘ └┴──┴┘└┴┘└┴─┐├──┴┘└┴┴┘└┘
;;                                          ┌─┘│                 
;;                                          └──┘          
;;
;;            Sistema Operacional Hexagonix® - Hexagonix® Operating System            
;;
;;                  Copyright © 2015-2023 Felipe Miguel Nery Lunkes
;;                Todos os direitos reservados - All rights reserved.
;;
;;************************************************************************************
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
;;************************************************************************************
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
;; Lista de prioridades para mensagens do sistema
;;
;; Compatibilidade:   Sistema Operacional Hexagonix® H1 ou superior
;; Versão:            1.0 rev 1 18/01/2023
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
.syslogd: db "syslogd", 0

;; Um macro simples para enviar mensagens para o log do sistema

macro logSistema mensagem, codigoErro, prioridade
{

    mov esi, mensagem   ;; Mensagem a ser enviada
    mov eax, codigoErro ;; Código de erro
    mov ebx, prioridade ;; Importante!

    hx.syscall enviarMensagemHexagon

}

;; syslogd deverá ser o mecanismo padrão para envio de mensagens de log quando
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

    hx.syscall iniciarProcesso

}