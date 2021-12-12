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
;;        $#$#%    &%$#@
;;        @#!$$    !#@#@
;;
;;
;;************************************************************************************
;;
;; Este arquivo contém definições úteis para o uso em todo o Sistema
;;
;; Essas definições incluem a versão do Sistema, assim como dados úteis a todos
;; os aplicativos Core do Andromeda®

;; Definições importantes para o uso destas funções
;;
;; enderecoCarregamento: fim do código do programa
;;
;; Formato do arquivo:
;;
;; [Versao]Nome de código"Build#Data e Hora!Build>

use32

limiteBusca = 8192
	
obterVersaoDistribuicao:

	pusha
	
	push es

	push ds
	pop es
	
	mov esi, arquivoVersao
	mov edi, enderecoCarregamento
	
	Andromeda abrir
	
	jc .erro
	
	mov si, enderecoCarregamento    ;; Aponta para o buffer com o conteúdo do arquivo
	mov bx, 0FFFFh                  ;; Inicia na posição -1, para que se possa encontrar os delimitadores
	
.procurarEntreDelimitadores:

	inc bx
	
	mov word[posicaoBXVerUtils], bx
	
	cmp bx, limiteBusca
	je .erro         ;; Caso nada seja encontrado até o tamanho limite, cancele a busca
	
	mov al, [ds:si+bx]
	
	cmp al, '['
	jne .procurarEntreDelimitadores ;; O limitador inicial foi encontrado
	
;; BX agora aponta para o primeiro caractere da versão do Sistema
	
	push ds
	pop es
	
	mov di, versaoObtida            ;; A versão será copiado para ES:DI
	
	mov si, enderecoCarregamento
	
	add si, bx				        ;; Mover SI para aonde BX aponta
	
	mov bx, 0				        ;; Iniciar em 0
	
.obterVersao:

	inc bx
	
	cmp bx, 64				
	je .erro                        ;; Se versão maior que 64 caracteres, a mesma é inválida     
	
	mov al, [ds:si+bx]
	
	cmp al, ']'					    ;; Se encontrar outro delimitador, a versão foi recuperada
	je .versaoObtida
	
;; Se não estiver pronto, armazenar o caractere obtido

	stosb
	
	jmp .obterVersao

.versaoObtida:

	pop es
	
	popa

    jmp obterCodigoDistribuicao
    
	ret

.erro:

    pop es
	
	popa
	
	mov eax, 01h

    stc

    ret

;;************************************************************************************
	
obterCodigoDistribuicao:

	pusha
	
	push es

	push ds
	pop es
	
	mov esi, arquivoVersao
	mov edi, enderecoCarregamento
	
	Andromeda abrir
	
	jc .erro
	
	mov si, enderecoCarregamento           ;; Aponta para o buffer com o conteúdo do arquivo
	mov bx, word [posicaoBXVerUtils]        ;; Continua de onde a opção anterior parou
	
	dec bx
	
.procurarEntreDelimitadores:

	inc bx
	
	mov word[posicaoBXVerUtils], bx
	
	cmp bx, limiteBusca
	
	je .erro        ;; Caso nada seja encontrado até o tamanho limite, cancele a busca
	
	mov al, [ds:si+bx]
	
	cmp al, ']'
	jne .procurarEntreDelimitadores ;; O limitador inicial foi encontrado
	
;; BX agora aponta para o primeiro caractere do nome de código recuperado do arquivo
	
	push ds
	pop es
	
	mov di, codigoObtido            ;; O nome de código será copiado para ES:DI
	
	mov si, enderecoCarregamento
	
	add si, bx				        ;; Mover SI para onde BX aponta
	
	mov bx, 0				        ;; Iniciar em 0
	
.obterCodigo:

	inc bx
	
	cmp bx, 64				
	je .erro                        ;; Se maior que 64, o mesmo é inválida    
	
	mov al, [ds:si+bx]
	
	cmp al, '"'					    ;; Se encontrar outro delimitador,o nome de código 	                                
	je .codigoObtido                ;; foi completamente recuperado
	
;; Se não estiver pronto, armazenar o caractere obtido

	stosb
	
	jmp .obterCodigo

.codigoObtido:

	pop es
	
	popa

    jmp obterPacoteDistribuicao

	ret

.erro:

    pop es
	
	popa
	
    mov eax, 02h

    stc

    ret

;;************************************************************************************
 
obterPacoteDistribuicao:

	pusha
	
	push es

	push ds
	pop es
	
	mov esi, arquivoVersao
	mov edi, enderecoCarregamento
	
	Andromeda abrir
	
	jc .erro
	
	mov si, enderecoCarregamento            ;; Aponta para o buffer com o conteúdo do arquivo
	mov bx, word [posicaoBXVerUtils]        ;; Continua de onde a opção anterior parou
	
	dec bx
	
.procurarEntreDelimitadores:

	inc bx
	
	mov word[posicaoBXVerUtils], bx
	
	cmp bx, limiteBusca
	
	je .erro  ;; Caso nada seja encontrado até o tamanho limite, cancele a busca
	
	mov al, [ds:si+bx]
	
	cmp al, '"'
	jne .procurarEntreDelimitadores ;; O limitador inicial foi encontrado
	
;; BX agora aponta para o primeiro caractere do pacote de atualizações do Sistema
	
	push ds
	pop es
	
	mov di, pacoteAtualizacoes          ;; O pacote será copiado para ES:DI
	
	mov si, enderecoCarregamento
	
	add si, bx				        ;; Mover SI para aonde BX aponta
	
	mov bx, 0				        ;; Iniciar em 0
	
.obterPacote:

	inc bx
	
	cmp bx, 64				
	je .erro           ;; Se maior que 64, é inválido     
	
	mov al, [ds:si+bx]
	
	cmp al, '#'					    ;; Se encontrar outro delimitador, foi carregado com sucesso
	je .pacoteObtido
	
;; Se não estiver pronto, armazenar o caractere obtido

	stosb
	
	jmp .obterPacote

.pacoteObtido:

	pop es
	
	popa

    jmp obterDataHora
	
.erro:

	pop es
	
	popa
	
    mov eax, 03h

    stc

    ret

;;************************************************************************************
 
obterDataHora:

	pusha
	
	push es

	push ds
	pop es
	
	mov esi, arquivoVersao
	mov edi, enderecoCarregamento
	
	Andromeda abrir
	
	jc .erro
	
	mov si, enderecoCarregamento            ;; Aponta para o buffer com o conteúdo do arquivo
	mov bx, word [posicaoBXVerUtils]        ;; Continua de onde a opção anterior parou
	
	dec bx
	
.procurarEntreDelimitadores:

	inc bx
	
	mov word[posicaoBXVerUtils], bx
	
	cmp bx, limiteBusca
	
	je .erro  ;; Caso nada seja encontrado até o tamanho limite, cancele a busca
	
	mov al, [ds:si+bx]
	
	cmp al, '#'
	jne .procurarEntreDelimitadores ;; O limitador inicial foi encontrado
	
;; BX agora aponta para o primeiro caractere da data e hora de lançamento
	
	push ds
	pop es
	
	mov di, dataHora                ;; Será copiado para ES:DI
	
	mov si, enderecoCarregamento
	
	add si, bx				        ;; Mover SI para aonde BX aponta
	
	mov bx, 0				        ;; Iniciar em 0
	
.recuperarDataHora:

	inc bx
	
	cmp bx, 64				
	je .erro           ;; Se maior que 64, é inválido     
	
	mov al, [ds:si+bx]
	
	cmp al, '!'					    ;; Se encontrar outro delimitador, foi carregado com sucesso
	je .dataHoraObtida
	
;; Se não estiver pronto, armazenar o caractere obtido

	stosb
	
	jmp .recuperarDataHora

.dataHoraObtida:

	pop es
	
	popa

    jmp obterBuildDistribuicao

	ret
	
.erro:

	pop es
	
	popa
	
    mov eax, 04h

    stc

    ret

;;************************************************************************************

obterBuildDistribuicao:

	pusha
	
	push es

	push ds
	pop es
	
	mov esi, arquivoVersao
	mov edi, enderecoCarregamento
	
	Andromeda abrir
	
	jc .erro
	
	mov si, enderecoCarregamento            ;; Aponta para o buffer com o conteúdo do arquivo
	mov bx, word [posicaoBXVerUtils]        ;; Continua de onde a opção anterior parou
	
	dec bx
	
.procurarEntreDelimitadores:

	inc bx
	
	mov word[posicaoBXVerUtils], bx
	
	cmp bx, limiteBusca
	
	je .erro  ;; Caso nada seja encontrado até o tamanho limite, cancele a busca
	
	mov al, [ds:si+bx]
	
	cmp al, '!'
	jne .procurarEntreDelimitadores ;; O limitador inicial foi encontrado
	
;; BX agora aponta para o primeiro caractere da build do Sistema
	
	push ds
	pop es
	
	mov di, buildObtida             ;; Será copiado ES:DI 
	
	mov si, enderecoCarregamento
	
	add si, bx				        ;; Mover SI para aonde BX aponta
	
	mov bx, 0				        ;; Iniciar em 0
	
.recuperarDataHora:

	inc bx
	
	cmp bx, 64				
	je .erro                        ;; Se nome de arquivo maior que 64, é inválido     
	
	mov al, [ds:si+bx]
	
	cmp al, '>'					    ;; Se encontrar outro delimitador, foi carregado com sucesso
	je .buildObtida
	
;; Se não estiver pronto, armazenar o caractere obtido

	stosb
	
	jmp .recuperarDataHora

.buildObtida:

	pop es
	
	popa

	ret
	
.erro:

	pop es
	
	popa
	
    mov eax, 04h

    stc

    ret

;;************************************************************************************

arquivoVersao:               db "ANDRMDA.OCL", 0
versaoObtida:       times 64 db 0
codigoObtido:       times 64 db 0
pacoteAtualizacoes: times 64 db 0
dataHora:           times 64 db 0
buildObtida:        times 64 db 0
posicaoBXVerUtils:           dw 0