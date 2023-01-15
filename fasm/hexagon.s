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
;; Cabeçalho de macros, funções e chamadas de Sistema do Hexagonix®
;;
;; Compatibilidade:   Sistema Operacional Hexagonix® H1 R1.2 (05/06/2022) ou superior
;;                    Hexagon® 9.3B ou mais recente (versão do kernel necessária)
;; Versão:            5.2 rev 0 05/06/2022
;; Autor:             Felipe Miguel Nery Lunkes
;;
;; Total de chamadas: 68 (26/04/2020) - Este número não é final e pode diminuir (ou aumentar)
;;
;;************************************************************************************
;;
;;          Funções de manipulação de vídeo oferecidas pelo Hexagonix®
;;
;;************************************************************************************

;;************************************************************************************
;;
;; Serviços de gerenciamento de memória e processos do Hexagonix®
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
;; Serviços de gerenciamento de arquivos e dispositivos do Hexagonix®
;;
;;************************************************************************************

abrir                  = 9             
escrever               = 10         
fechar                 = 11          

;;************************************************************************************
;;
;; Serviços de gerenciamento do Sistema de Arquivos e de volumes do Hexagonix®
;;
;;************************************************************************************

salvarArquivo          = 13    
deletarArquivo         = 14  
listarArquivos         = 15           
arquivoExiste          = 16     
obterDisco             = 17        

;;************************************************************************************
;;
;; Serviços de gerenciamento de usuários do Hexagonix®
;;
;;************************************************************************************

travar                 = 18            
destravar              = 19        
definirUsuario         = 20   
obterUsuario           = 21     

;;************************************************************************************
;;
;; Serviços oferecidos pelo Hexagonix®
;;
;;************************************************************************************

retornarVersao         = 22    
obterAleatorio         = 23   
alimentarAleatorio     = 24 
causarAtraso           = 25     
instalarISR            = 26       

;;************************************************************************************
;;
;; Serviços de gerenciamento de energia do Hexagonix®
;;
;;************************************************************************************

reiniciarPC            = 27                   
desligarPC             = 28      

;;************************************************************************************
;;
;; Serviços de saída em vídeo e gráficos do Hexagonix®
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
;; Serviços de manipulação de teclado PS/2 do Hexagonix®
;;
;;************************************************************************************

aguardarTeclado        = 45   
obterString            = 46       
obterEstadoTeclas      = 47 
alterarFonte           = 48      
alterarLeiaute         = 49    

;;************************************************************************************
;;
;; Serviços de manipulação de mouse PS/2 do Hexagonix®
;;
;;************************************************************************************

aguardarMouse          = 50    
obterMouse             = 51        
definirMouse           = 52      

;;************************************************************************************
;;
;; Serviços de manipulação e conversão de dados do Hexagonix®
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
;;  Serviços de saída por som do Hexagonix®
;;
;;************************************************************************************  

emitirSom              = 64        
desligarSom            = 65       

;;************************************************************************************
;;
;;  Serviços de mensagens do Hexagonix®
;;
;;************************************************************************************  

enviarMensagemHexagon  = 66 

;;************************************************************************************                      

;;************************************************************************************
;;
;;  Serviço de relógio em tempo real do Hexagon®
;;
;;************************************************************************************  

retornarData           = 67     
retornarHora           = 68     

;;************************************************************************************

malloc = 1
mfree  = 2
fork   = 3

;;************************************************************************************

;; Histórico de funções com nome substituído

;; encerrarProcesso             = 4 (Adaptação a partir de terminarPrograma completa em 06/11/2020)
;; iniciarProcesso              = 3 (Adaptação a partir de carregarPrograma completa em 06/11/2020)

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