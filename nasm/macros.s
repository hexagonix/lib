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
;; Cabeçalho de macros, estruturas, funções e chamadas para o desenvolvimento de 
;; aplicativos e utilitários
;;
;;************************************************************************************
;;
;;              Biblioteca de desenvolvimento Cosmos para Hexagonix®/Andromeda®
;;
;; Versão: 2.0 rev 0 (14/06/2019)
;; Compatibilidade: Hexagonix®/Andromeda® 1.12+ (14/06/2019)
;;
;;************************************************************************************
 
;; Utilize o macro Abrir para carregar um arquivo ou então para estabelecer comunicação
;; com um dispositivo conectado ao computador.
;; Para arquivo, o endereço de destino  deve ser fornecido. Já para dispositivo, o nome
;; deve ser seguido de 0.

%macro Abrir 2

    mov esi, [%1]
    mov edi, [%2]

    Hexagonix abrir

%endmacro

%macro finalizarProcesso 2

    mov eax, [%1]
    mov ebx, [%2]

    Hexagonix encerrarProcesso

%endmacro


%macro tocarNota 1

    mov ax, [%1]
    mov bx, 00h

    Hexagonix emitirSom

%endmacro

%macro tocarNotaT 2

    mov ax, [%1]
    mov bx, 00h

    Hexagonix emitirSom

    mov ecx, [%2]

    Hexagonix causarAtraso

    Hexagonix desligarSom

%endmacro

%macro pausar 1 
{

    mov ecx, [%1] 
    
    Hexagonix causarAtraso

%endmacro

%macro finalizarNota

    Hexagonix desligarSom
    
%endmacro

%macro cursorPara 2

    mov dl, [%1]
	mov dh, [%2]

	Hexagonix definirCursor

%endmacro