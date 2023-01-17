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
;;                  Hexagon® 9.3B ou mais recente (versão do kernel necessária)
;; Versão:          6.0 rev 0 17/01/2023
;;
;; Total de chamadas: 68 (26/04/2020) - Este número não é final e pode diminuir (ou aumentar)
;;
;; $ENGLISH$
;;
;; Header of Hexagonix® Macros, Functions and System Calls
;;
;; Compatibility: Hexagonix® H1 R1.2 (05/06/2022) or higher
;;                Hexagon® 9.3B or newer (kernel version required)
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

alocarMemoria          = 1      
liberarMemoria         = 2   
iniciarProcesso        = 3    
encerrarProcesso       = 4   
obterPID               = 5          
usoMemoria             = 6                                    
obterProcessos         = 7    
obterCodigoErro        = 8   

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de gerenciamento de arquivos e dispositivos do Hexagon®
;; $ENGLISH$   Hexagon® file and device management services
;;
;;************************************************************************************

abrir                  = 9             
escrever               = 10         
fechar                 = 11          

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de gerenciamento do Sistema de Arquivos e de volumes do Hexagon®
;; $ENGLISH$   Hexagon® File System and volume management services
;;
;;************************************************************************************

salvarArquivo          = 13    
deletarArquivo         = 14  
listarArquivos         = 15           
arquivoExiste          = 16     
obterDisco             = 17        

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de gerenciamento de usuários do Hexagon®
;; $ENGLISH$   Hexagon® user management services
;;
;;************************************************************************************

travar                 = 18            
destravar              = 19        
definirUsuario         = 20   
obterUsuario           = 21     

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços oferecidos pelo Hexagon®
;; $ENGLISH$   Services offered by Hexagon®
;;
;;************************************************************************************

retornarVersao         = 22    
obterAleatorio         = 23   
alimentarAleatorio     = 24 
causarAtraso           = 25     
instalarISR            = 26       

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de gerenciamento de energia do Hexagon®
;; $ENGLISH$   Hexagon® power management services 
;;
;;************************************************************************************

reiniciarPC            = 27                   
desligarPC             = 28      

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de saída em vídeo e gráficos do Hexagon®
;; $ENGLISH$   Hexagon® graphics and video output services
;;
;;************************************************************************************

imprimir               = 29                                                          
limparTela             = 30                     
limparLinha            = 31      
NULA                   = 32            
rolarTela              = 33         
definirCursor          = 34     
desenharCaractere      = 35 
desenharBloco          = 36    
imprimirCaractere      = 37 
definirCor             = 38       
obterCor               = 39         
obterInfoTela          = 40        
atualizarTela          = 41                       
definirResolucao       = 42  
obterResolucao         = 43   
obterCursor            = 44      
                                            
;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de manipulação de teclado PS/2 do Hexagon®
;; $ENGLISH$   Hexagon® PS/2 keyboard handling services
;;
;;************************************************************************************

aguardarTeclado        = 45   
obterString            = 46       
obterEstadoTeclas      = 47 
alterarFonte           = 48      
alterarLeiaute         = 49    

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de manipulação de mouse PS/2 do Hexagon®
;; $ENGLISH$   Hexagon® PS/2 mouse handling services
;;
;;************************************************************************************

aguardarMouse          = 50    
obterMouse             = 51        
definirMouse           = 52      

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de manipulação e conversão de dados do Hexagon®
;; $ENGLISH$   Hexagon® data manipulation and conversion services
;;
;;************************************************************************************

compararPalavrasString = 53 
removerCaractereString = 54 
inserirCaractere       = 55            
tamanhoString          = 56      
compararString         = 57     
stringParaMaiusculo    = 58 
stringParaMinusculo    = 59 
cortarString           = 60        
encontrarCaractere     = 61      
stringParaInt          = 62      
paraString             = 63       

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de saída por som do Hexagon®
;; $ENGLISH$   Hexagon® sound output services
;;
;;************************************************************************************  

emitirSom              = 64        
desligarSom            = 65       

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviços de mensagens do Hexagon®
;; $ENGLISH$   Hexagon® messaging services
;;
;;************************************************************************************  

enviarMensagemHexagon  = 66 

;;************************************************************************************                      

;;************************************************************************************
;;
;; $PORTUGUÊS$ Serviço de relógio em tempo real do Hexagon®
;; $ENGLISH$   Hexagon® real time clock service
;;
;;************************************************************************************  

retornarData           = 67     
retornarHora           = 68     

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
;; hx hx.função
;;     ou
;; sys hx.função
;;     ou
;; Hexagonix hx.função
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
;; hx hx.function
;;       or
;; sys hx.function
;;       or
;; Hexagonix hx.function
;;
;;************************************************************************************

hx.malloc             = 1
hx.mfree              = 2
hx.spawn              = 3
hx.exit               = 4
hx.getpid             = 5
hx.open               = 9
hx.write              = 10
hx.close              = 11
hx.link               = 13
hx.unlink             = 14
hx.indir              = 15
hx.syslock            = 18
hx.sysunlock          = 19
hx.uname              = 22
hx.sleep              = 25
hx.date               = 67
hx.time               = 68

;;************************************************************************************

;;************************************************************************************
;;
;;                   Chamar Interrupção de Software Hexagonix®
;;                                    Macros
;;
;;************************************************************************************

macro Hexagonix chamadaHexagon ;; Macro utilizado para solicitar um serviço do Hexagon®
{

    push chamadaHexagon 
    
    int 69h     
    
}

macro sys chamadaHexagon ;; Macro utilizado para solicitar um serviço do Hexagon®
{

    push chamadaHexagon 
    
    int 69h     
    
}

macro hx chamadaHexagon ;; Macro utilizado para solicitar um serviço do Hexagon®
{

    push chamadaHexagon 
    
    int 69h     
    
}

macro novaLinha
{
    
    push ebx
    
    xor ebx, ebx
    
    mov al, 10              ;; 10 é o caractere de nova linha
    
    pop ebx
    
    Hexagonix imprimirCaractere
    
}

macro imprimirInteiro
{

    mov ebx, 01h
    
    Hexagonix imprimir

}

macro imprimirHexadecimal
{

    mov ebx, 02h
    
    Hexagonix imprimir
    
}

macro imprimirBinario
{

    mov ebx, 03h
    
    Hexagonix imprimir

}

macro imprimirString
{

    mov ebx, 04h
    
    Hexagonix imprimir

}

macro imprimir conteudo     ;; Macro utilizado para imprimir determinado conteúdo na tela para o usuário
{

    mov esi, conteudo
    
    imprimirString
    
}   

;; Fim do arquivo