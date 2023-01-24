;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2023 Felipe Miguel Nery Lunkes
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
;; $PORTUGUÊS$
;;
;; Cabeçalho de macros, funções e chamadas de Sistema do Hexagonix®
;;
;; Compatibilidade: Sistema Operacional Hexagonix® H1 R1.2 (05/06/2022) ou superior
;;                  Hexagon® 1.0 ou mais recente (versão do kernel necessária)
;; Versão:          6.0 rev 0 17/01/2023
;;
;; Total de chamadas: 68 (26/04/2020) - Este número não é final e pode diminuir (ou aumentar)
;;
;; $ENGLISH$
;;
;; Header of Hexagonix® Macros, Functions and System Calls
;;
;; Compatibility: Hexagonix® H1 R1.2 (05/06/2022) or higher
;;                Hexagon® 1 0 or newer (kernel version required)
;;                Version: 6.0 rev 0 01/17/2023
;;
;; Total calls: 68 (04/26/2020) - This number is not final and may decrease (or increase)
;;
;;************************************************************************************

;;************************************************************************************
;;
;; $PORTUGUÊS$ Tabela 1: Chamadas de sistema do Hexagon
;; $ENGLISH$   Table 1: Hexagon System Calls
;;
;;************************************************************************************

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de gerenciamento de memória e processos do Hexagon®
;; $ENGLISH$   Hexagon® memory and process management services
;;
;;************************************************************************************

alocarMemoria          equ 1      
liberarMemoria         equ 2   
iniciarProcesso        equ 3    
encerrarProcesso       equ 4   
obterPID               equ 5          
usoMemoria             equ 6                                    
obterProcessos         equ 7    
obterCodigoErro        equ 8   

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de gerenciamento de arquivos e dispositivos do Hexagon®
;; $ENGLISH$   Hexagon® file and device management services
;;
;;************************************************************************************

abrir                  equ 9             
escrever               equ 10         
fechar                 equ 11          

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de gerenciamento do Sistema de Arquivos e de volumes do Hexagon®
;; $ENGLISH$   Hexagon® File System and volume management services
;;
;;************************************************************************************

salvarArquivo          equ 13    
deletarArquivo         equ 14  
listarArquivos         equ 15           
arquivoExiste          equ 16     
obterDisco             equ 17        

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de gerenciamento de usuários do Hexagon®
;; $ENGLISH$   Hexagon® user management services
;;
;;************************************************************************************

travar                 equ 18            
destravar              equ 19        
definirUsuario         equ 20   
obterUsuario           equ 21     

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços oferecidos pelo Hexagon®
;; $ENGLISH$   Services offered by Hexagon®
;;
;;************************************************************************************

retornarVersao         equ 22    
obterAleatorio         equ 23   
alimentarAleatorio     equ 24 
causarAtraso           equ 25     
instalarISR            equ 26       

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de gerenciamento de energia do Hexagon®
;; $ENGLISH$   Hexagon® power management services 
;;
;;************************************************************************************

reiniciarPC            equ 27                   
desligarPC             equ 28      

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de saída em vídeo e gráficos do Hexagon®
;; $ENGLISH$   Hexagon® graphics and video output services
;;
;;************************************************************************************

imprimir               equ 29                                                          
limparTela             equ 30                     
limparLinha            equ 31      
NULA                   equ 32            
rolarTela              equ 33         
definirCursor          equ 34     
desenharCaractere      equ 35 
desenharBloco          equ 36    
imprimirCaractere      equ 37 
definirCor             equ 38       
obterCor               equ 39         
obterInfoTela          equ 40        
atualizarTela          equ 41                       
definirResolucao       equ 42  
obterResolucao         equ 43   
obterCursor            equ 44      
                                            
;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de manipulação de teclado PS/2 do Hexagon®
;; $ENGLISH$   Hexagon® PS/2 keyboard handling services
;;
;;************************************************************************************

aguardarTeclado        equ 45   
obterString            equ 46       
obterEstadoTeclas      equ 47 
alterarFonte           equ 48      
alterarLeiaute         equ 49    

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de manipulação de mouse PS/2 do Hexagon®
;; $ENGLISH$   Hexagon® PS/2 mouse handling services
;;
;;************************************************************************************

aguardarMouse          equ 50    
obterMouse             equ 51        
definirMouse           equ 52      

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de manipulação e conversão de dados do Hexagon®
;; $ENGLISH$   Hexagon® data manipulation and conversion services
;;
;;************************************************************************************

compararPalavrasString equ 53 
removerCaractereString equ 54 
inserirCaractere       equ 55            
tamanhoString          equ 56      
compararString         equ 57     
stringParaMaiusculo    equ 58 
stringParaMinusculo    equ 59 
cortarString           equ 60        
encontrarCaractere     equ 61      
stringParaInt          equ 62      
paraString             equ 63       

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de saída por som do Hexagon68®
;; $ENGLISH$   Hexagon® sound output services
;;
;;************************************************************************************  

emitirSom              equ 64        
desligarSom            equ 65       

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de mensagens do Hexagon®
;; $ENGLISH$   Hexagon® messaging services
;;
;;************************************************************************************  

enviarMensagemHexagon  equ 66 

;;************************************************************************************                      

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviço de relógio em tempo real do Hexagon®
;; $ENGLISH$   Hexagon® real time clock service
;;
;;************************************************************************************  

retornarData           equ 67     
retornarHora           equ 68     

;;************************************************************************************

;;************************************************************************************
;;
;; $PORTUGUÊS$ Tabela 2: Padronização de nomes de função com Version 7 UNIX
;; $ENGLISH$   Table 2: Function name standardization with Version 7 UNIX
;;
;;************************************************************************************
;;
;; $PORTUGUÊS$
;;
;; Tabela de padronização de nomes de função com Version 7 UNIX
;;
;; Observações importantes sobre essa tabela:
;;
;; - O Hexagon expõe uma série de funções ao ambiente de usuário. Muitas dessas funções
;; não estão disponíveis no Version 7 UNIX ou vice e versa. Muitas funções expostas pelo
;; Version 7 UNIX não estarão disponíveis aqui, uma vez que o Hexagonix não busca
;; compatibilidade com esse sistema, mas se inspira na arquitetura. Como exemplo, temos
;; a ausência das funções mount() e unmount(). No Hexagon, a montagem e desmontagem de um
;; volume se dá pelas funções open() e close(). Apesar de tentar ser um sistema Unix-like,
;; a implementação é bem diferente. Além disso, a chamada uname() não está disponível no
;; Version 7 UNIX, mas está disponível no Hexagonix. No mais, as chamadas de sistema 
;; do Hexagon apresentam um comportamento totalmente diferente do Version 7 UNIX, embora
;; o comportamento de algumas foi escrito para se assemelhar ao máximo.
;;
;; O Hexagon expõe uma série de funções para facilitar o desenvolvimento de utilitários.
;; Junta-se a isso o fato do motor de renderização gráfica estar no kernel. Assim, funções
;; para exibir caracteres e desenhar pixels na tela, presentes no kernel, foram adaptadas
;; e expostas ao ambiente de usuário. A tabela acima (Tabela 1: Chamadas de sistema do Hexagon)
;; contêm todas as chamadas disponíveis na versão atual do Hexagonix. Com a evolução do
;; software, se espera que muitas delas sejam transferidas completamente para o ambiente
;; de usuário.
;;
;; Para chamar a função, use:
;; 
;; hx.syscall hx.função
;;     ou
;; sys hx.função
;;
;; $ENGLISH$
;; 
;; Table of function name standardization with Version 7 UNIX
;;
;; Important notes about this table:
;;
;; - Hexagon exposes a series of functions to the user environment. Many of these functions
;; are not available on Version 7 UNIX or vice versa. Many functions exposed by
;; Version 7 UNIX will not be available here, as Hexagonix does not aims compatibility
;; with that system, but is inspired by the architecture. As an example, we have the absence of
;; the mount() and unmount() functions. At Hexagon, mounting and dismounting a volume is given
;; by the open() and close() functions. Despite trying to be a Unix-like system, the implementation 
;; is quite different. Also, the uname() call is not available in Version 7 UNIX, but is available
;; on Hexagonix. Furthermore, system calls of Hexagon behave completely different from Version 7
;; UNIX, although the behavior of some was written to resemble as closely as possible.
;;
;; Hexagon exposes a number of functions to facilitate the development of utilities.
;; Added to this is the fact that the graphics rendering engine is in the kernel. So, functions
;; to display characters and draw pixels on the screen, present in the kernel, were adapted
;; and exposed to the user environment. The table above (Table 1: Hexagon System Calls)
;; contain all calls available in the current version of Hexagonix. With the evolution of
;; software, it is expected that many of them will be transferred completely to the user
;; environment.
;;
;; To call the function, use:
;;
;; hx.syscall hx.function
;;       or
;; sys hx.function
;;
;;************************************************************************************

hx.malloc             equ 1
hx.mfree              equ 2
hx.spawn              equ 3
hx.exit               equ 4
hx.getpid             equ 5
hx.open               equ 9
hx.write              equ 10
hx.close              equ 11
hx.creat              equ 13
hx.unlink             equ 14
hx.indir              equ 15
hx.syslock            equ 18
hx.sysunlock          equ 19
hx.uname              equ 22
hx.sleep              equ 25
hx.putc               equ 29
hx.date               equ 67
hx.time               equ 68

;;************************************************************************************
;;
;;                   Chamar Interrupção de Software Hexagonix®
;;                                    Macros
;;
;;************************************************************************************

%macro hx.syscall 1 ;; Macro utilizado para solicitar um serviço do Hexagon®

    push [%1]   
    
    int 69h     

%endmacro

%macro novaLinha 0
    
    push ebx
    
    xor ebx, ebx
    
    mov al, 10              ;; 10 é o caractere de nova linha
    
    pop ebx
    
    hx.syscall imprimirCaractere
    
%endmacro

%macro imprimirInteiro 0

    mov ebx, 01h
    
    hx.syscall imprimir

%endmacro

%macro imprimirHexadecimal 0

    mov ebx, 02h
    
    hx.syscall imprimir

%endmacro

%macro imprimirBinario 0

    mov ebx, 03h
    
    hx.syscall imprimir

%endmacro

%macro imprimirString 0

    mov ebx, 04h
    
    hx.syscall imprimir

%endmacro

%macro imprimir 1     ;; Macro utilizado para imprimir determinado conteúdo na tela para o usuário

    mov esi, [%1]
    
    imprimirString
    
%endmacro

%macro fputs 1    

    mov esi, [%1]
    
    imprimirString
    
%endmacro

%macro puts 1    

    mov esi, [%1]
    
    imprimirString
    
    novaLinha
    
%endmacro