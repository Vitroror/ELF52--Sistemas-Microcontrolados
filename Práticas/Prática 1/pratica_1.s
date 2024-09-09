;-----------------------------------------------------------------------------------------------------------
; ATIVIDADE PR�TICA 1																					   -
; FEITO POR VICTOR AUGUSTO DEL MONEGO(2378345), THIAGO MELCHER ARM�NIO(2358565) E MURILO CAPPONI(2358506)  -
;-----------------------------------------------------------------------------------------------------------

;--------------------------
;	"STARTUP" DO PROGRAMA -
;--------------------------

	AREA DATA, ALIGN=2
	AREA	|.text|, CODE, READONLY, ALIGN=2
	THUMB
	
	EXPORT Start

;-----------------------------
;	"PR�-INICIO" DO PROGRAMA -
;-----------------------------

LISTNUM EQU 0x20000400		; endere�o da lista de n�meros aleat�rios que v�o alimentar o programa
PRIMERAMNUM EQU 0x20000500	; endere�o da lista de n�meros primos
LISTSIZE EQU 0x20000600		; endere�o de onde ser� armazenado o tamanho da lista de n�meros

;-----------------------
;	IN�CIO DO PROGRAMA -
;-----------------------

Start

	LDR R9, =LISTNUM		; carregando o endere�o da lista de numeros inseridos da RAM
	LDR R10, =PRIMERAMNUM	; carrega o endere�o da lista de numeros primos da RAM
	LDR R11, =ROMNUM		; carrega o endere�o da lista de n�meros da ROM
	MOV R1, #0				; inicializa r1 como sendo 0
	LDR R2, =LISTSIZE		; aponta R2 para o endere�o de LISTSIZE

StrIteration
	
	LDRB R0, [R11], #1		; Carrega o o valor do endere�o armazenado em R11 incrementado em 1 em R0
	STRB R0, [R9], #1		; Armazena o valor de R0 no endere�o de R9 e incrementa 1 em R9
	ADD R1, #1				; incrementa em 1 o valor de r1, sendo esse o "tamanho" da lista
	CMP R0, #0				; Testa se est� no fim da lista
	BNE StrIteration		; Se flag Z=1, chegou ao fim da lista, se n�o retorna ao come�o da fun��o
	
	LDR R12, =LISTNUM		; Carrega o endere�o da lista para o registrador
	STR R1, [R2]			; armazena o valor de R1 no endere�o de memoria de LISTSIZE
	
;----------------------------------------
; FUN��O PARA DEFINIR OS N�MEROS PRIMOS -
;----------------------------------------

CarregarPrimo
	LDRB R1, [R12], #1		; Carrega o o valor do endere�o armazenado em R12 incrementado em 1 em R1
	MOV R2, #2				; Move 2 para R2
	CMP R1, #0				; Testa se est� no fim da lista
	BEQ SortingTime			; Se Z=1 pula para a fun��o, se n�o ainda faltam n�meros a serem adicionados � lista de primos
	
PrimeIteration
	MOV R0, #2				; gera uma constante de valor 2
	UDIV R0, R1, R0 		; armazena em r0 o valor do n�mero verificado pela constante 2
	CMP R2, R0				; Compara o valor de r2 (valor da itera��o) com r0 (metade do n�mero verificado)
	BEQ PrimeDefine			; Se Z=1 pula para fun��o
	UDIV R3, R1, R2			; Divide R1 por R2 e guarda o resultado em R3
	MLS R4, R2, R3, R1		; Esta opera��o indicar� se a anterior possuia resto e guarda o resultado em R4
	CMP R4, #0				; Compara R4 a 0
	BEQ CarregarPrimo		; Se z=1 cai para a fun��o
	ADD R2, #1				; Incrementa 1 ao valor de R2
	B PrimeIteration		; Vai para o in�cio da fun��o
	
PrimeDefine
	STRB R1, [R10], #1		; Armazena o valor de R1 no endere�o de R10 e incrementa 1 em R10
	B CarregarPrimo			; Vai para a fun��o
	
;---------------------
; FUN��O BUBBLE SORT -
;---------------------

SortingTime
	MOV R5, #0				; Move 0 para R5
	LDR R6, =PRIMERAMNUM	; Ponteiro para o endere�o
	LDR R7, =PRIMERAMNUM+1	; Ponteiro para o endere�o seguinte
	
BubbleSort
	LDRB R8, [R6]			; Carrega o valor do endere�o em R6 para R8
	LDRB R1, [R7]			; Carrega o valor do endere�o em R1 para R7
	CMP R1, #0				; Testa se � o fim da lista
	BEQ FinishSort			; Se z=1 vai para a fun��o
	CMP R1, R8
	;UDIV R0, R1, R8		; Divide R1 por R8 e guarda em R0
	;CMP R0, #1				; Compara R0 com 1
	BMI Sort				; Se N!=V vai para a fun��o
	ADD R6, #1				; Incrementa 1 em R6
	ADD R7, #1				; Incrementa 1 em R7
	B BubbleSort			; Vai para a fun��o
	
Sort
	ADD R5, #1				; Incrementa 1 em R5
	STRB R1, [R6], #1		; Armazena o valor de R1 no endere�o de R6 e incrementa 1 em R6
	STRB R8, [R7], #1		; Armazena o valor de R8 no endere�o de R7 e incrementa 1 em R7
	B BubbleSort			; Vai para a fun��o
	
FinishSort
	CMP R5, #0				; Testa se a lista est� ordenada
	BNE SortingTime			; Se n�o estiver retorna a fun��o

;------------------
; FIM DO PROGRAMA -
;------------------

	NOP
	
ROMNUM DCB 193, 63, 176, 127, 43, 13, 211, 3, 203, 5, 21, 7, 206, 245, 157, 237, 241, 105, 252, 19

	ALIGN
	END