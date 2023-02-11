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
;; Compatibilidade:   Sistema Operacional Hexagonix® H1 ou superior
;;                    Hexagon® 1.0 ou superior
;; Versão:            1.0 rev 2 18/01/2023
;; Autor:             Felipe Miguel Nery Lunkes
;;
;;************************************************************************************

struc cabecalhoHAPP ARQUITETURA, verMin, subVerMin, entrada, tipoImagem
{

;; Especificação HAPP2 (HAPP 2.0 rev 0)

assinatura:      db "HAPP"
arquitetura:     db ARQUITETURA
versaoMinima:    db verMin
subVersaoMinima: db subVerMin
pontoEntrada:    dd entrada
tipoImagemHAPP:  db tipoImagem
reservado0:      dd 0      ;; Reservado (Dword)
reservado1:      db 0      ;; Reservado (Byte)
reservado2:      db 0      ;; Reservado (Byte)
reservado3:      db 0      ;; Reservado (Byte)
reservado4:      dd 0      ;; Reservado (Dword)
reservado5:      dd 0      ;; Reservado (Dword)
reservado6:      dd 0      ;; Reservado (Dword)
reservado7:      db 0      ;; Reservado (Byte)
reservado8:      dw 0      ;; Reservado (Word)
reservado9:      dw 0      ;; Reservado (Word)
reservado10:     dw 0      ;; Reservado (Word)

}

HAPP.Arquiteturas:

.i386  = 01h ;; Padrão
.amd64 = 02h

;; Outras, um dia

HAPP.tipoImagem: ;; Tipos de imagem HAPP que podem ser declaradas no cabeçalho

.exec      = 01h
.lib       = 02h ;; Para bibliotecas (ainda em implementação)
.dlib      = 03h ;; Uso futuro (bibliotecas dinamicamente carregadas)
.reservado = 04h ;; Essa imagem armazena dados, não é executável