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
;;        $#$#%    &%$#@
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
;;              Biblioteca de desenvolvimento Cosmos para Andromeda®
;;
;; Versão: 2.0 rev 0 (14/06/2019)
;; Compatibilidade: Andromeda® 1.12+ (14/06/2019)
;;
;;************************************************************************************
 
;; Utilize o macro Abrir para carregar um arquivo ou então para estabelecer comunicação
;; com um dispositivo conectado ao computador.
;; Para arquivo, o endereço de destino  deve ser fornecido. Já para dispositivo, o nome
;; deve ser seguido de 0.

macro Abrir nome, endereco
{

    mov esi, nome
    mov edi, endereco

    Andromeda abrir

}

macro finalizarProcesso codigoErro, tipoSaida
{

    mov eax, codigoErro
    mov ebx, tipoSaida

    Andromeda encerrarProcesso

}

macro finalizarProcessoGrafico codigoErroGrafico, tipoSaidaGrafico
{

    Andromeda limparTela

    finalizarProcesso codigoErroGrafico, tipoSaidaGrafico

}

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

macro cursorPara posicaoX, posicaoY
{

    mov dl, posicaoX
	mov dh, posicaoY

	Andromeda definirCursor

}