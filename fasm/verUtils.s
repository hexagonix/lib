;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2015-2023 Felipe Miguel Nery Lunkes
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
;; Este arquivo contém definições úteis para o uso em todo o sistema
;;
;; Essas definições incluem a versão do sistema, assim como dados úteis a todos
;; os aplicativos core do Hexagonix®
;;
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
    
    hx.syscall abrir
    
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
    
;; BX agora aponta para o primeiro caractere da versão do sistema
    
    push ds
    pop es
    
    mov di, versaoObtida            ;; A versão será copiado para ES:DI
    
    mov si, enderecoCarregamento
    
    add si, bx                      ;; Mover SI para aonde BX aponta
    
    mov bx, 0                       ;; Iniciar em 0
    
.obterVersao:

    inc bx
    
    cmp bx, 64              
    je .erro                        ;; Se versão maior que 64 caracteres, a mesma é inválida     
    
    mov al, [ds:si+bx]
    
    cmp al, ']'                     ;; Se encontrar outro delimitador, a versão foi recuperada
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
    
    hx.syscall abrir
    
    jc .erro
    
    mov si, enderecoCarregamento      ;; Aponta para o buffer com o conteúdo do arquivo
    mov bx, word [posicaoBXVerUtils]  ;; Continua de onde a opção anterior parou
    
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
    
    add si, bx                      ;; Mover SI para onde BX aponta
    
    mov bx, 0                       ;; Iniciar em 0
    
.obterCodigo:

    inc bx
    
    cmp bx, 64              
    je .erro                        ;; Se maior que 64, o mesmo é inválida    
    
    mov al, [ds:si+bx]
    
    cmp al, '"'                     ;; Se encontrar outro delimitador,o nome de código                                     
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
    
    hx.syscall abrir
    
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
    
;; BX agora aponta para o primeiro caractere do pacote de atualizações do sistema
    
    push ds
    pop es
    
    mov di, pacoteAtualizacoes      ;; O pacote será copiado para ES:DI
    
    mov si, enderecoCarregamento
    
    add si, bx                      ;; Mover SI para aonde BX aponta
    
    mov bx, 0                       ;; Iniciar em 0
    
.obterPacote:

    inc bx
    
    cmp bx, 64              
    je .erro           ;; Se maior que 64, é inválido     
    
    mov al, [ds:si+bx]
    
    cmp al, '#'        ;; Se encontrar outro delimitador, foi carregado com sucesso
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
    
    hx.syscall abrir
    
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
    
    add si, bx                      ;; Mover SI para aonde BX aponta
    
    mov bx, 0                       ;; Iniciar em 0
    
.recuperarDataHora:

    inc bx
    
    cmp bx, 64              
    je .erro           ;; Se maior que 64, é inválido     
    
    mov al, [ds:si+bx]
    
    cmp al, '!'                     ;; Se encontrar outro delimitador, foi carregado com sucesso
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
    
    hx.syscall abrir
    
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
    
;; BX agora aponta para o primeiro caractere da build do sistema
    
    push ds
    pop es
    
    mov di, buildObtida             ;; Será copiado ES:DI 
    
    mov si, enderecoCarregamento
    
    add si, bx                      ;; Mover SI para aonde BX aponta
    
    mov bx, 0                       ;; Iniciar em 0
    
.recuperarDataHora:

    inc bx
    
    cmp bx, 64              
    je .erro                        ;; Se nome de arquivo maior que 64, é inválido     
    
    mov al, [ds:si+bx]
    
    cmp al, '>'                     ;; Se encontrar outro delimitador, foi carregado com sucesso
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

arquivoVersao:               db "HEXGNIX.OCL", 0
versaoObtida:       times 64 db 0
codigoObtido:       times 64 db 0
pacoteAtualizacoes: times 64 db 0
dataHora:           times 64 db 0
buildObtida:        times 64 db 0
posicaoBXVerUtils:           dw 0