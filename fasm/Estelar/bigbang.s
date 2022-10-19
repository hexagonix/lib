;;************************************************************************************
;;
;;    
;;        %#@$%    &@$%$                  Kernel Hexagon®
;;        #$@$@    #@#@$
;;        @#@$%    %#$#%
;;        @#$@$    #@#$@
;;        #@#$$#$#%!@#@#     Copyright © 2016-2022 Felipe Miguel Nery Lunkes
;;        @#@%!@&$#&$#@#             Todos os direitos reservados
;;        !@$%#    @&$%#
;;        @$#!%    #&*@&
;;        $#$#%    &%$#@          Licenciado sob licença BSD-3-Clause
;;        @#!$$    !#@#@
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
;;
;;************************************************************************************
;;
;; Cabeçalho de macros, estruturas, funções e chamadas para o desenvolvimento de 
;; aplicativos e utilitários
;;
;;************************************************************************************
;;
;;              Biblioteca de desenvolvimento Big-Bang para Hexagonix®
;;
;; Versão:  1 rev 0 (22/11/2020)
;; Compatibilidade: Hexagonix® 1.14+ (22/11/2020)
;;
;;************************************************************************************

macro tocarNota frequencia
{

    mov ax, frequencia
    mov bx, 00h

    Hexagonix emitirSom

}

macro tocarNotaT frequencia, temporizador
{

    mov ax, frequencia
    mov bx, 00h

    Hexagonix emitirSom

    mov ecx, temporizador

    Hexagonix causarAtraso

    Hexagonix desligarSom

}

macro pausar tempo 
{

    mov ecx, tempo 
    
    Hexagonix causarAtraso

}

macro finalizarNota
{

    Hexagonix desligarSom
    
}
