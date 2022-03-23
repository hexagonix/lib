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
;; Este arquivo contém definições úteis para o uso em todo o Sistema
;;
;; Essas definições incluem a versão do Sistema, assim como dados úteis a todos
;; os aplicativos Core do Andromeda®

sistemaBase: ;; Dados de desenvolvimento OEM

;; Versão da distribuição do Sistema. Esta versão difere da do Hexagon®

;; Banner apenas para exibição. 
                                       
.versaoAndromeda: db "1.0.3 [Thena]", 0 

;; Para tratamento, usar opções abaixo, em inteiro e string

.versao:     db 1
.subversao:  db 0
.revisao:    db 3
.lancamento: db 0
.codenome:   db "Thena",0
.montagem:   dw 213

;; Informações do pacote de atualizações de construção do Sistema

.pacoteAtualizacoes: db "Thena.PE 03.03 Arishem", 0

;; Informações gerais da construção do Sistema

.ano:     db "2022", 0
.mes:     db "03", 0
.dia:     db "22", 0
.hora:    db "23", 0
.minutos: db "30", 0

;; Forma de ler o código da construção:
;; 1) Tipo de liberação: RC (Release Candidate), OF (Oficial) ou TB (Teste Beta)
;; 2) Pacote de atualizações
;; 3) Versão do Sistema base
;; 4) Número da construção
;; 5) Codenome do Sistema base
;; À partir de 2), existem delimitadores, na forma de vírgula
;; Caso exista um @ depois da semana, significa o início da semana
;; Caso exista um ! depois da semana, significa o fim da semana
;;
;; Exemplo:
;; 1)   2)     3)    4)     5)
;; RC S1.10 , 1.5 , 195 , Aurora

.build:  db "OFS3@.03,1.0.3,0213.Arishem,Thena", 0
