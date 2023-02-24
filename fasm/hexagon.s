;;*************************************************************************************************
;;
;; 88                                                                                88              
;; 88                                                                                ""              
;; 88                                                                                                
;; 88,dPPPba,   ,adPPPba, 8b,     ,d8 ,adPPPPba,  ,adPPPb,d8  ,adPPPba,  8b,dPPPba,  88 8b,     ,d8  
;; 88P'    "88 a8P     88  `P8, ,8P'  ""     `P8 a8"    `P88 a8"     "8a 88P'   `"88 88  `P8, ,8P'   
;; 88       88 8PP"""""""    )888(    ,adPPPPP88 8b       88 8b       d8 88       88 88    )888(     
;; 88       88 "8b,   ,aa  ,d8" "8b,  88,    ,88 "8a,   ,d88 "8a,   ,a8" 88       88 88  ,d8" "8b,   
;; 88       88  `"Pbbd8"' 8P'     `P8 `"8bbdP"P8  `"PbbdP"P8  `"PbbdP"'  88       88 88 8P'     `P8  
;;                                               aa,    ,88                                         
;;                                                "P8bbdP"       
;;
;;            Sistema Operacional Hexagonix® - Hexagonix® Operating System            
;;
;;                  Copyright © 2015-2023 Felipe Miguel Nery Lunkes
;;                Todos os direitos reservados - All rights reserved.
;;
;;*************************************************************************************************
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
;;*************************************************************************************************
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
;; Cabeçalho de macros, funções e chamadas de Sistema do Hexagonix®
;;
;; Compatibilidade: Sistema Operacional Hexagonix® H1 R1.2 (05/06/2022) ou superior
;;                  Hexagon® 1.0 ou mais recente (versão do kernel necessária)
;; Versão:          6.0 rev 0 17/01/2023
;;
;; Total de chamadas: 68 (26/04/2020) - Este número não é final e pode diminuir (ou aumentar)
;;
;;************************************************************************************

;;************************************************************************************
;;
;; Tabela 1: Chamadas de sistema do Hexagon
;;
;;************************************************************************************

alocarMemoria          = 1  ;; Serviços de gerenciamento de memória e processos do Hexagon®
liberarMemoria         = 2  ;; Serviços de gerenciamento de memória e processos do Hexagon®
iniciarProcesso        = 3  ;; Serviços de gerenciamento de memória e processos do Hexagon®
encerrarProcesso       = 4  ;; Serviços de gerenciamento de memória e processos do Hexagon®
obterPID               = 5  ;; Serviços de gerenciamento de memória e processos do Hexagon®
usoMemoria             = 6  ;; Serviços de gerenciamento de memória e processos do Hexagon®
obterProcessos         = 7  ;; Serviços de gerenciamento de memória e processos do Hexagon®
obterCodigoErro        = 8  ;; Serviços de gerenciamento de memória e processos do Hexagon®
abrir                  = 9  ;; Serviços de gerenciamento de arquivos e dispositivos do Hexagon®
escrever               = 10 ;; Serviços de gerenciamento de arquivos e dispositivos do Hexagon®
fechar                 = 11 ;; Serviços de gerenciamento de arquivos e dispositivos do Hexagon®
salvarArquivo          = 13 ;; Serviços de gerenciamento do Sistema de Arquivos e de volumes do Hexagon®
deletarArquivo         = 14 ;; Serviços de gerenciamento do Sistema de Arquivos e de volumes do Hexagon®
listarArquivos         = 15 ;; Serviços de gerenciamento do Sistema de Arquivos e de volumes do Hexagon®
arquivoExiste          = 16 ;; Serviços de gerenciamento do Sistema de Arquivos e de volumes do Hexagon®
obterDisco             = 17 ;; Serviços de gerenciamento do Sistema de Arquivos e de volumes do Hexagon®
travar                 = 18 ;; Serviços de gerenciamento de usuários do Hexagon®
destravar              = 19 ;; Serviços de gerenciamento de usuários do Hexagon®
definirUsuario         = 20 ;; Serviços de gerenciamento de usuários do Hexagon®
obterUsuario           = 21 ;; Serviços de gerenciamento de usuários do Hexagon®
retornarVersao         = 22 ;; Serviços oferecidos pelo Hexagon®
obterAleatorio         = 23 ;; Serviços oferecidos pelo Hexagon®
alimentarAleatorio     = 24 ;; Serviços oferecidos pelo Hexagon®
causarAtraso           = 25 ;; Serviços oferecidos pelo Hexagon®
instalarISR            = 26 ;; Serviços oferecidos pelo Hexagon®
reiniciarPC            = 27 ;; Serviços de gerenciamento de energia do Hexagon®
desligarPC             = 28 ;; Serviços de gerenciamento de energia do Hexagon®
imprimir               = 29 ;; Serviços de saída em vídeo e gráficos do Hexagon®
limparTela             = 30 ;; Serviços de saída em vídeo e gráficos do Hexagon®
limparLinha            = 31 ;; Serviços de saída em vídeo e gráficos do Hexagon®
rolarTela              = 33 ;; Serviços de saída em vídeo e gráficos do Hexagon®
definirCursor          = 34 ;; Serviços de saída em vídeo e gráficos do Hexagon®
desenharCaractere      = 35 ;; Serviços de saída em vídeo e gráficos do Hexagon®
desenharBloco          = 36 ;; Serviços de saída em vídeo e gráficos do Hexagon®
imprimirCaractere      = 37 ;; Serviços de saída em vídeo e gráficos do Hexagon®
definirCor             = 38 ;; Serviços de saída em vídeo e gráficos do Hexagon®
obterCor               = 39 ;; Serviços de saída em vídeo e gráficos do Hexagon®
obterInfoTela          = 40 ;; Serviços de saída em vídeo e gráficos do Hexagon®
atualizarTela          = 41 ;; Serviços de saída em vídeo e gráficos do Hexagon®
definirResolucao       = 42 ;; Serviços de saída em vídeo e gráficos do Hexagon®
obterResolucao         = 43 ;; Serviços de saída em vídeo e gráficos do Hexagon®
obterCursor            = 44 ;; Serviços de saída em vídeo e gráficos do Hexagon®
aguardarTeclado        = 45 ;; Serviços de manipulação de teclado PS/2 do Hexagon®
obterString            = 46 ;; Serviços de manipulação de teclado PS/2 do Hexagon®
obterEstadoTeclas      = 47 ;; Serviços de manipulação de teclado PS/2 do Hexagon®
alterarFonte           = 48 ;; Serviços de manipulação de teclado PS/2 do Hexagon®
alterarLeiaute         = 49 ;; Serviços de manipulação de teclado PS/2 do Hexagon®
aguardarMouse          = 50 ;; Serviços de manipulação de mouse PS/2 do Hexagon®
obterMouse             = 51 ;; Serviços de manipulação de mouse PS/2 do Hexagon®
definirMouse           = 52 ;; Serviços de manipulação de mouse PS/2 do Hexagon®
compararPalavrasString = 53 ;; Serviços de manipulação e conversão de dados do Hexagon®
removerCaractereString = 54 ;; Serviços de manipulação e conversão de dados do Hexagon®
inserirCaractere       = 55 ;; Serviços de manipulação e conversão de dados do Hexagon®
tamanhoString          = 56 ;; Serviços de manipulação e conversão de dados do Hexagon®
compararString         = 57 ;; Serviços de manipulação e conversão de dados do Hexagon®
stringParaMaiusculo    = 58 ;; Serviços de manipulação e conversão de dados do Hexagon®
stringParaMinusculo    = 59 ;; Serviços de manipulação e conversão de dados do Hexagon®
cortarString           = 60 ;; Serviços de manipulação e conversão de dados do Hexagon®
encontrarCaractere     = 61 ;; Serviços de manipulação e conversão de dados do Hexagon®
stringParaInt          = 62 ;; Serviços de manipulação e conversão de dados do Hexagon®
paraString             = 63 ;; Serviços de manipulação e conversão de dados do Hexagon®
emitirSom              = 64 ;; Serviços de saída por som do Hexagon®
desligarSom            = 65 ;; Serviços de saída por som do Hexagon®
enviarMensagemHexagon  = 66 ;; Serviços de mensagens do Hexagon®
retornarData           = 67 ;; Serviço de relógio em tempo real do Hexagon®
retornarHora           = 68 ;; Serviço de relógio em tempo real do Hexagon®

;;************************************************************************************
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
;; Table 1: Hexagon System Calls
;;
;;************************************************************************************

allocateMemory         = 1  ;; Hexagon® memory and process management services
freeMemory             = 2  ;; Hexagon® memory and process management services
startProcess           = 3  ;; Hexagon® memory and process management services
endProcess             = 4  ;; Hexagon® memory and process management services
getPID                 = 5  ;; Hexagon® memory and process management services
memoryUse              = 6  ;; Hexagon® memory and process management services
getProcesses           = 7  ;; Hexagon® memory and process management services
getErrorCode           = 8  ;; Hexagon® memory and process management services
HXopen                 = 9  ;; Hexagon® File and Device Management Services
HXwrite                = 10 ;; Hexagon® File and Device Management Services
HXclose                = 11 ;; Hexagon® File and Device Management Services
saveFile               = 13 ;; Hexagon® File System and Volume Management Services
deleteFile             = 14 ;; Hexagon® File System and Volume Management Services
listFiles              = 15 ;; Hexagon® File System and Volume Management Services
fileExists             = 16 ;; Hexagon® File System and Volume Management Services
getDisk                = 17 ;; Hexagon® File System and Volume Management Services
HXlock                 = 18 ;; Hexagon® User Management Services
HXunlock               = 19 ;; Hexagon® User Management Services
defineUser             = 20 ;; Hexagon® User Management Services
getUser                = 21 ;; Hexagon® User Management Services
returnVersion          = 22 ;; Services offered by Hexagon®
getRandom              = 23 ;; Services offered by Hexagon®
feedRandom             = 24 ;; Services offered by Hexagon®
causeDelay             = 25 ;; Services offered by Hexagon®
installISR             = 26 ;; Services offered by Hexagon®
restartPC              = 27 ;; Hexagon® Power Management Services
shutdownPC             = 28 ;; Hexagon® Power Management Services
HXprint                = 29 ;; Hexagon® Graphics and Video Output Services
clearScreen            = 30 ;; Hexagon® Graphics and Video Output Services
clearLine              = 31 ;; Hexagon® Graphics and Video Output Services
scrollScreen           = 33 ;; Hexagon® Graphics and Video Output Services
setCursor              = 34 ;; Hexagon® Graphics and Video Output Services
drawCharacter          = 35 ;; Hexagon® Graphics and Video Output Services
drawBlock              = 36 ;; Hexagon® Graphics and Video Output Services
printCharacter         = 37 ;; Hexagon® Graphics and Video Output Services
setColor               = 38 ;; Hexagon® Graphics and Video Output Services
getColor               = 39 ;; Hexagon® Graphics and Video Output Services
getScreenInfo          = 40 ;; Hexagon® Graphics and Video Output Services
updateScreen           = 41 ;; Hexagon® Graphics and Video Output Services
defineResolution       = 42 ;; Hexagon® Graphics and Video Output Services
getResolution          = 43 ;; Hexagon® Graphics and Video Output Services
getCursor              = 44 ;; Hexagon® Graphics and Video Output Services
awaitKeyboard          = 45 ;; Hexagon® PS/2 Keyboard Handling Services
getString              = 46 ;; Hexagon® PS/2 Keyboard Handling Services
getKeyState            = 47 ;; Hexagon® PS/2 Keyboard Handling Services
changeFont             = 48 ;; Hexagon® PS/2 Keyboard Handling Services
changeLayout           = 49 ;; Hexagon® PS/2 Keyboard Handling Services
waitMouse              = 50 ;; Hexagon® PS/2 Mouse Handling Services
getMouse               = 51 ;; Hexagon® PS/2 Mouse Handling Services
setMouse               = 52 ;; Hexagon® PS/2 Mouse Handling Services
compareWordsString     = 53 ;; Hexagon® data manipulation and conversion services
removeCharacterString  = 54 ;; Hexagon® data manipulation and conversion services
insertCharacter        = 55 ;; Hexagon® data manipulation and conversion services
stringSize             = 56 ;; Hexagon® data manipulation and conversion services
compareString          = 57 ;; Hexagon® data manipulation and conversion services
stringToUppercase      = 58 ;; Hexagon® data manipulation and conversion services
stringToLowercase      = 59 ;; Hexagon® data manipulation and conversion services
cutString              = 60 ;; Hexagon® data manipulation and conversion services
findCharacter          = 61 ;; Hexagon® data manipulation and conversion services
stringToInt            = 62 ;; Hexagon® data manipulation and conversion services
intToString            = 63 ;; Hexagon® data manipulation and conversion services
emitSom                = 64 ;; Hexagon® Sound Output Services
offSound               = 65 ;; Hexagon® Sound Output Services
sendMessageHexagon     = 66 ;; Hexagon® Messaging Services
returnDate             = 67 ;; Hexagon® Real Time Clock Service
returnTime             = 68 ;; Hexagon® Real Time Clock Service

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

hx.malloc             = 1
hx.mfree              = 2
hx.spawn              = 3
hx.exit               = 4
hx.getpid             = 5
hx.open               = 9
hx.write              = 10
hx.close              = 11
hx.creat              = 13
hx.unlink             = 14
hx.indir              = 15
hx.syslock            = 18
hx.sysunlock          = 19
hx.uname              = 22
hx.sleep              = 25
hx.putc               = 29
hx.date               = 67
hx.time               = 68

;;************************************************************************************

;;************************************************************************************
;;
;;                                    libasm
;;                                    Macros
;;
;;************************************************************************************

macro sys chamadaHexagon ;; Macro utilizado para solicitar um serviço do Hexagon®
{

    push chamadaHexagon 
    
    int 69h     
    
}

macro hx.syscall chamadaHexagon ;; Macro utilizado para solicitar um serviço do Hexagon®
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
    
    hx.syscall imprimirCaractere
    
}

macro imprimirInteiro
{

    mov ebx, 01h
    
    hx.syscall imprimir

}

macro imprimirHexadecimal
{

    mov ebx, 02h
    
    hx.syscall imprimir
    
}

macro imprimirBinario
{

    mov ebx, 03h
    
    hx.syscall imprimir

}

macro imprimirString
{

    mov ebx, 04h
    
    hx.syscall imprimir

}

macro imprimir conteudo ;; Macro utilizado para imprimir determinado conteúdo no console
{

    mov esi, conteudo
    
    imprimirString
    
}   

;; O macro fputs não adiciona uma nova linha após enviar o conteúdo para o console

macro fputs string     ;; Macro utilizado para imprimir determinado conteúdo no console
{

    mov esi, string
    
    imprimirString
    
}   

;; O macro puts adiciona uma nova linha após enviar o conteúdo para o console

macro puts string      ;; Macro utilizado para imprimir determinado conteúdo no console
{

    mov esi, string
    
    imprimirString
    
    novaLinha

}   

;; Fim do arquivo
