;;************************************************************************************
;;
;;    
;;        %#@$%&@$%&@$%$             Sistema Operacional Andromeda®
;;        #$@$@$@#@#@#@$
;;        @#@$%    %#$#%
;;        @#$@$    #@#$@
;;        #@#$$    !@#@#     Copyright © 2016-2022 Felipe Miguel Nery Lunkes
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
;; Compatibilidade:   Sistema Operacional Andromeda® 1.14.4 (12/12/2020) ou superior
;; Versão:            1.0 rev 1 12/12/2020
;; Autor:             Felipe Miguel Nery Lunkes
;;
;;************************************************************************************

;; Erros de entrada e saída (I/O)

IO:

.escritaNegada   = 1
.leituraNegada   = 2 
.erroLeitura     = 3
.erroEscrita     = 4
.operacaoNegada  = 5

Hexagon:

.imagemAusente   = 1
.erroCarregando  = 2
.limiteProcessos = 3
.imagemInvalida  = 4
