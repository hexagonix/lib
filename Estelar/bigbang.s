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
;;        $#$#%    &%$#@        Big-Bang - biblioteca de som do Andromeda®
;;        @#!$$    !#@#@
;;
;;
;;************************************************************************************
;;
;; Cabeçalho de macros, estruturas, funções e chamadas para o desenvolvimento de 
;; aplicativos e utilitários
;;
;;************************************************************************************
;;
;;              Biblioteca de desenvolvimento Big-Bang para Andromeda®
;;
;; Versão:  1 rev 0 (22/11/2020)
;; Compatibilidade: Andromeda® 1.14+ (22/11/2020)
;;
;;************************************************************************************

macro tocarNota frequencia
{

    mov ax, frequencia
    mov bx, 00h

    Andromeda emitirSom

}

macro tocarNotaT frequencia, temporizador
{

    mov ax, frequencia
    mov bx, 00h

    Andromeda emitirSom

    mov ecx, temporizador

    Andromeda causarAtraso

    Andromeda desligarSom

}

macro pausar tempo 
{

    mov ecx, tempo 
    
    Andromeda causarAtraso

}

macro finalizarNota
{

    Andromeda desligarSom
    
}
