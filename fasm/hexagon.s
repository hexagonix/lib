;;************************************************************************************
;;
;;    
;; ┌┐ ┌┐                                 Sistema Operacional Hexagonix®
;; ││ ││
;; │└─┘├──┬┐┌┬──┬──┬──┬─┐┌┬┐┌┐    Copyright © 2016-2022 Felipe Miguel Nery Lunkes
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
;; Copyright (c) 2015-2022, Felipe Miguel Nery Lunkes
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
;; Cabeçalho de macros, funções e chamadas de sistema do Hexagonix®
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

alocarMemoria = 1      ;; Alocar memória
                       ;; Entrada: EAX - Tamanho da memória solicitada, em bytes
                       ;; Saída: EBX - Ponteiro para a memória alocada

liberarMemoria = 2     ;; Liberar memória
                       ;; Entrada: EBX - Ponteiro para a memória alocada
                       ;; ECX - Tamanho da memória alocada

iniciarProcesso = 3    ;; Carregar programa do disco e o executar
                       ;; Entrada: ESI - Nome do programa; EDI - Argumentos; EAX = 0 se não forem passados argumentos
                       ;; Saída: CF definido em caso de erro ou programa não encontrado

encerrarProcesso = 4   ;; Terminar o processo atualmente em execução
                       ;; Entrada: EAX - Código de erro, caso exista
                       ;; EBX = 0 se apenas terminar a execução; EBX = 0x1234 para manter residente

obterPID = 5           ;; Retorna o indentificador do processo em execução
                       ;; Saída: EAX - PID do processo

usoMemoria = 6         ;; Retorna estatísticas de uso deste recurso, calculados pelo Sistema                                       
                       ;; Saída: EAX - Memória utilizada, em bytes
                       ;; EBX - Memória total disponível para uso, em bytes                        
                       ;; ECX - Memória total disponível para uso, em Mbytes (menos preciso)
                       ;; EDX - Memória reservada para o Hexagon®, em bytes
                       ;; ESI - Memória total alocada (resevada+processos), em kbytes
                                  
obterProcessos = 7     ;; Obtêm os processos presentes na pilha de execução                                       
                       ;; Saída: ESI - Lista de processos; EAX - Número de processos na pilha                                 

obterCodigoErro = 8    ;; Obtém o código retornado pelo último processo em execução.
                       ;; Saída: EAX - Código de erro (0 para sem erro/saída normal)

;;************************************************************************************
;;
;; Serviços de gerenciamento de arquivos e dispositivos do Hexagonix®
;;
;;************************************************************************************

abrir = 9              ;; Abre um canal de leitura/escrita com determinado dispositivo solicitado ou 
                       ;; arquivo comum presente no disco (dispositivos e discos são tratados como
                       ;; arquivos). Em caso de arquivo no disco, um endereço de carregamento deve ser 
                       ;; fornecido.                                                    
                       ;; Entrada: ESI - Ponteiro para o buffer que contêm o nome convencionado
                       ;; EDI - Endereço de carregamento, em caso de arquivo
                       ;; CF definido quando o nome do dispositivo for inválido ou arquivo não existir

escrever = 10          ;; Envia dados para o dispositivo aberto
                       ;; Entrada: SI - Ponteiro com o buffer contendo os dados
                       ;; Saída: CF definido em caso de erro ou nenhum dispositivo aberto
                       ;; Aviso! Futuramente, será utilizada para salvar arquivos.

fechar = 11            ;; Fecha o último dispositivo aberto

;;************************************************************************************
;;
;; Serviços de gerenciamento do Sistema de Arquivos e de volumes do Hexagonix®
;;
;;************************************************************************************

salvarArquivo = 13     ;; Salvar um arquivo no disco
                       ;; Entrada: ESI - Ponteiro para o nome do arquivo; EDI - Ponteiro para o conteúdo
                       ;; Entrada: EAX - Tamanho do arquivo
                       ;; Saída: CF definido em caso de erro ou arquivo já presente
                         
deletarArquivo  = 14   ;; Remover um arquivo do disco
                       ;; Entrada: ESI - Ponteiro para o nome do arquivo
                       ;; Saída: CF definido em caso de erro ou arquivo não existente

listarArquivos  = 15   ;; Obter lista de arquivos       
                       ;; Saída: ESI - Ponteiro para a lista de arquivos; EAX - Total de arquivos
                                  
arquivoExiste = 16     ;; Checar se um arquivo existe no disco
                       ;; Entrada: ESI - Nome do arquivo para checar
                       ;; Saída: EAX - Tamanho do arquivo
                       ;; CF definido se o arquivo não existir             

obterDisco = 17        ;; Obtêm o disco utilizado pelo sistema
                       ;; Saída: ESI - Nome do dispositivo 
                       ;;        EDI - Rótulo do volume utilizado                                

;;************************************************************************************
;;
;; Serviços de gerenciamento de usuários do Hexagonix®
;;
;;************************************************************************************

travar = 18            ;; Bloqueia o processo em primeiro plano, impedindo que o mesmo seja terminado
                       ;; pelo usuário utilizando uma tecla especial ou combinação.
                       ;; A tecla F1 é no Hexagonix® a tecla "Matar processo".
                       ;; Esta tecla pode ter sua função removida com o tempo.

destravar = 19         ;; Habilita que o usuário mate o processo em execução pressionando uma tecla especial
                       ;; ou combinação de teclas. A tecla "Matar processo" (F1) se torna habilitada.
                       ;; Esta tecla pode ter sua função removida com o tempo.
                                   
definirUsuario = 20    ;; Define um usuário para a sessão.
                       ;; Entrada: EAX - ID do grupo; ESI - Nome do usuário

obterUsuario = 21      ;; Obtêm dados do usuário logado na sessão
                       ;; Saída: EAX - ID do grupo; ESI - Nome do usuário

;;************************************************************************************
;;
;; Serviços oferecidos pelo Hexagonix®
;;
;;************************************************************************************

retornarVersao = 22    ;; Retorna a versão do Sistema para os aplicativos
                       ;; Saída: EAX - Número da versão; EBX - Número da subversão 
                       ;; CH - Caractere de revisão; EDX - Arquitetura
                       ;; ESI - Nome do Kernel 
                       ;; EDI - Build do Kernel

obterAleatorio = 23    ;; Obtêr um número aleatório
                       ;; Entrada: EAX - Máximo
                       ;; Saída: EAX - Número

alimentarAleatorio = 24 ;; Alimentar o gerador do números
                        ;; Entrada: EAX - Número

causarAtraso = 25      ;; Utilizada para causar um atraso (delay), utilizado para adaptar operações
                       ;; de memória, operações de disco e possibilitar leitura da tela por parte
                       ;; do usuário.
                       ;; Entrada: ECX - Tempo em unidades de contagem para causar atraso
 
instalarISR = 26       ;; Instalar rotina de serviço de interrupção
                       ;; Entrada: EAX - Número da interrupção; ESI - Ponteiro para o manipulador

;;************************************************************************************
;;
;; Serviços de gerenciamento de energia do Hexagonix®
;;
;;************************************************************************************

reiniciarPC = 27       ;; Reiniciar o computador
                    
desligarPC = 28        ;; Chama rotina da implementação APM do Hexagonix® para desligar o computador

;;************************************************************************************
;;
;; Serviços de saída em vídeo e gráficos do Hexagonix®
;;
;;************************************************************************************

imprimir = 29          ;; Imprimir um conteúdo definido em um dispositivo de saída
                       ;; Entrada:
                       ;;
                       ;; EAX - Conteúdo numérico, se este for o caso, respeitando os
                       ;;       formatos abaixo designados. Os formatos devem ser informados!
                       ;; ESI - Ponteiro para a string à ser impressa, se este for o caso.     
                       ;; EBX - Tipo de entrada, que pode ser:
                       ;;       01h - Inteiro decimal
                       ;;       02h - Inteiro hexadecimal
                       ;;       03h - Inteiro binário
                       ;;       04h - String        
                       ;; Dica! Utilize os macros no fim do arquivo para utilizar essa função                                                         

limparTela = 30        ;; Limpa a tela      
                        
limparLinha = 31       ;; Limpa uma linha específica na tela
                       ;; Entrada: AL - Número da linha 
                        
NULA  = 32             ;; Função nula, sem retorno ou função
                       ;; Mantida para compatibilidade

rolarTela = 33         ;; Rola a tela para baixo uma linha

definirCursor = 34     ;; Definir cursor em uma posição específica
                       ;; Entrada: DL - X; DH - Y

desenharCaractere = 35 ;; Colocar um pixel na tela
                       ;; Entrada: EAX - X; EBX - Y; EDX - Cor em hexadecimal

desenharBloco = 36     ;; Desenhar um bloco de cor específica
                       ;; Entrada: EAX - X; EBX - Y; ESI - Comprimento
                       ;; Entrada: EDI - Altura; EDX - Cor em hexadecimal

imprimirCaractere = 37 ;; Imprimir caractere na posição do cursor 
                       ;; Entrada: AL - Caractere; EBX - 01h para posicionar cursor                             

definirCor = 38        ;; Definir cor de fundo e primeiro plano
                       ;; Entrada: EAX - Cor da fonte (RGB em hexadecimal)
                       ;; EBX - Cor do plano de fundo (RGB em hexadecimal)
                       ;; ECX - 1234h para alterar o tema padrão para os valores solicitados
                       ;; Em modo texto, apenas preto e branco são permitidos
                         
obterCor = 39          ;; Obter cor de fundo e primeiro plano
                       ;; Saída: EAX - Plano de fundo (RGB em hexadecimal)
                       ;; EBX - Plano de fundo (RGB em hexadecimal)
                       ;; ECX - Cor padrão da fonte, no tema atual
                       ;; EDX - Cor padrão do plano de fundo, no tema atual
                       ;; Em modo texto, apenas preto e branco são permitidos

obterInfoTela = 40     ;; Obter informação da tela
                       ;; Saída: EAX - Resolução X (bits 0..15), Y (bits 16..31),
                       ;; EBX - Colunas (bit 0..7), Linhas (8..15), Bits por pixel (16..23),
                       ;; EDX - Endereço do início do frame de vídeo
                       ;; CF definido em caso de modo texto
                                        
atualizarTela = 41     ;; Atualizar a memória de vídeo com o conteúdo do Buffer
                                
definirResolucao = 42  ;; Utilizado para definir a resolução à ser utilizada no vídeo
                       ;; Entrada: EAX - Número relativo a resolução à ser utilizada
                       ;;       1 - Resolução de 800x600 pixels
                       ;;       2 - Resolução de 1024x768 pixels  
                       ;;       3 - Alterar para modo texto 

obterResolucao = 43    ;; Utilizado para obter o código relativo à resolução utilizada 
                       ;; no vídeo padrão
                       ;; Saída: EAX - Número relativo a resolução atualmente utilizada
                       ;;       1 - Resolução de 800x600 pixels
                       ;;       2 - Resolução de 1024x768 pixels
                                   
obterCursor = 44       ;; Obter posição do cursor
                       ;; Saída: DL - X, DH - Y
                                            

;;************************************************************************************
;;
;; Serviços de manipulação de teclado PS/2 do Hexagonix®
;;
;;************************************************************************************

aguardarTeclado = 45   ;; Esperar pelo pressionamento de uma tecla no teclado
                       ;; Saída: AL - Caratere; AH - Scan code
                              
obterString = 46       ;; Obter string do teclado
                       ;; Entrada: AL - Máximo de caracteres para receber
                       ;; EBX - Presença ou não de eco durante a digitação - 1234h
                       ;; para desativar o eco e <> 1234h para ativar
                       ;; Saída: ESI - String
                         
obterEstadoTeclas = 47 ;; Obter status das teclas especiais
                       ;; Saída: EAX - Status das teclas especiais
                       ;; 
                       ;; Formato:
                       ;;
                       ;; bit 0: Tecla Control
                       ;; bit 1: Tecla Shift
                       ;; bit 2-31: Reservado

alterarFonte = 48      ;; Altera a fonte padrão de exibição do sistema
                       ;; Entrada: ESI - Ponteiro para o buffer contendo o nome do arquivo
                       ;; que contêm a fonte compatível com o Sistema Operacional Hexagonix®
                       ;; Saída: CF definido em caso de arquivo não encontrado                                                                          

alterarLeiaute = 49    ;; Altera o leiaute do teclado
                       ;; Entrada: ESI - Arquivo contendo um leiaute de teclado válido

;;************************************************************************************
;;
;; Serviços de manipulação de mouse PS/2 do Hexagonix®
;;
;;************************************************************************************

aguardarMouse = 50     ;; Aguardar por evento do mouse
                       ;; Saída: EAX - X; EBX - Y; EDX - Botões

obterMouse = 51        ;; Obter posição atual do mouse e estado dos botões
                       ;; Saída: EAX - X; EBX - Y; EDX - Botões

definirMouse = 52      ;; Definir nova posição do mouse
                       ;; Entrada: EAX - X; EBX Y

;;************************************************************************************
;;
;; Serviços de manipulação e conversão de dados do Hexagonix®
;;
;;************************************************************************************

compararPalavrasString = 53 ;; Comparar primeiras words de duas strings 
                            ;; Entrada: ESI - Primeira string; EDI - Segunda string 
                            ;; Saída: CF definido se iguais

removerCaractereString = 54 ;; Remover um caractere de uma posição específica na string 
                            ;; Entrada: ESI - String; EAX - Posição do caractere

inserirCaractere = 55  ;; Inserir um caractere em posição específica da string
                       ;; Entrada: ESI - String; EDX - Caractere para inserir; AL - Caractere para inserir
                                  
tamanhoString = 56     ;; Onter o tamanho de uma string 
                       ;; Entrada: ESI - String. 
                       ;; Saída: AX - Tamanho da string

compararString = 57    ;; Comparar duas strings 
                       ;; Entrada: ESI - Primeira string; EDI - Segunda string 
                       ;; Saída: CF definido se as duas forem iguais

stringParaMaiusculo = 58 ;; Converter string para maiúsculo
                         ;; Entrada: ESI - String

stringParaMinusculo = 59 ;; Converter string para minúsculo 
                         ;; Entrada: ESI - String 

cortarString = 60      ;; Remover espaços em branco da string
                       ;; Entrada: ESI - String.

encontrarCaractere = 61 ;; Encontrar caractere específico na string
                        ;; Entrada: ESI - String, AL - caractere para encontrar
                        ;; Saída: EAX - Número de ocorrências do caractere
                        ;; CF definido se caractere não encontrado
                              
stringParaInt = 62     ;; Converter um número string para número inteiro
                       ;; Entrada: ESI - String
                       ;; Saída: EAX - Inteiro
                       ;; CF definido em caso e número inválido

paraString = 63        ;; Converte um número inteiro em uma string
                       ;; Entrada: EAX - Inteiro à ser convertido
                       ;; Saída: ESI - Ponteiro para o buffer contendo o conteúdo 

;;************************************************************************************
;;
;;  Serviços de saída por som do Hexagonix®
;;
;;************************************************************************************  

emitirSom = 64         ;; Toca um tom no alto-falante interno do computador
                       ;; Entrada: AX - Frequência à ser reproduzida

desligarSom = 65       ;; Desliga o alto-falante interno do computador, interrompendo
                       ;; qualquer emissão de som em progresso                               

;;************************************************************************************
;;
;;  Serviços de mensagens do Hexagonix®
;;
;;************************************************************************************  

enviarMensagemHexagon = 66 ;; Envia uma mensagem de alta prioridade do Hexagon
                           ;; Entrada: ESI - Mensagem
                           ;;          EAX - Código de erro, se houver
                           ;;          EBX - Prioridade 

;;************************************************************************************                      

;;************************************************************************************
;;
;;  Serviço de relógio em tempo real do Hexagon®
;;
;;************************************************************************************  

retornarData = 67      ;; Retorna informações de relógio em tempo real em formato
                       ;; ASCII (String). Conversão para número pode ser necessária
                       ;; Saída: EAX - Dia, em ASCII
                       ;;        EBX - Mês, em ASCII
                       ;;        ECX - Século, em ASCII
                       ;;        EDX - Ano, em ASCII

retornarHora = 68      ;; Retorna informações de relógio em tempo real em formato
                       ;; ASCII (String). Conversão para número pode ser necessária
                       ;;        EAX - Hora, em ASCII
                       ;;        EBX - Minuto, em ASCII
                       ;;        ECX - Segundo, em ASCII

;;************************************************************************************
;;
;;                   Chamar Interrupção de Software Hexagonix®
;;               Aliases de nome de função para padronização futura
;;    Estes aliases servem para implementar mudanças na padronização sem quebrar as 
;;     chamadas em código que ainda não teve a nomenclatura de chamada atualizada
;;
;; Após ataliação de todos os códigos, as funções podem ter o nome alterado e os
;; aliases podem ser removidos
;;
;;************************************************************************************

malloc = 1
mfree  = 2
fork   = 3

;; Histórico de funções com nome substituído

;; encerrarProcesso             = 4 (Adaptação a partir de terminarPrograma completa em 06/11/2020)
;; iniciarProcesso              = 3 (Adaptação a partir de carregarPrograma completa em 06/11/2020)

;;************************************************************************************
;;
;;                   Chamar Interrupção de Software Andromeda®
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