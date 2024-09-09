;-----------------------------------------------------------------------------------------------------------
; ATIVIDADE PRÁTICA 1																					   -
; FEITO POR VICTOR AUGUSTO DEL MONEGO(2378345), THIAGO MELCHER ARMÊNIO(2358565) E MURILO CAPPONI(2358506)  -
;-----------------------------------------------------------------------------------------------------------

;--------------------------
;	"STARTUP" DO PROGRAMA -
;--------------------------

	AREA DATA, ALIGN=2
	AREA	|.text|, CODE, READONLY, ALIGN=2
	THUMB
	
	EXPORT Start

;-----------------------------
;	"PRÉ-INICIO" DO PROGRAMA -
;-----------------------------

LISTNUM EQU 0x20000400		; endereço da lista de números aleatórios que vão alimentar o programa
PRIMERAMNUM EQU 0x20000500	; endereço da lista de números primos
LISTSIZE EQU 0x20000600		; endereço de onde será armazenado o tamanho da lista de números

;-----------------------
;	INÍCIO DO PROGRAMA -
;-----------------------

Start

	LDR R9, =LISTNUM		; carregando o endereço da lista de numeros inseridos da RAM
	LDR R10, =PRIMERAMNUM	; carrega o endereço da lista de numeros primos da RAM
	LDR R11, =ROMNUM		; carrega o endereço da lista de números da ROM
	MOV R1, #0				; inicializa r1 como sendo 0
	LDR R2, =LISTSIZE		; aponta R2 para o endereço de LISTSIZE

StrIteration
	
	LDRB R0, [R11], #1		; Carrega o o valor do endereço armazenado em R11 incrementado em 1 em R0
	STRB R0, [R9], #1		; Armazena o valor de R0 no endereço de R9 e incrementa 1 em R9
	ADD R1, #1				; incrementa em 1 o valor de r1, sendo esse o "tamanho" da lista
	CMP R0, #0				; Testa se está no fim da lista
	BNE StrIteration		; Se flag Z=1, chegou ao fim da lista, se não retorna ao começo da função
	
	LDR R12, =LISTNUM		; Carrega o endereço da lista para o registrador
	STR R1, [R2]			; armazena o valor de R1 no endereço de memoria de LISTSIZE
	
;----------------------------------------
; FUNÇÃO PARA DEFINIR OS NÚMEROS PRIMOS -
;----------------------------------------

CarregarPrimo
	LDRB R1, [R12], #1		; Carrega o o valor do endereço armazenado em R12 incrementado em 1 em R1
	MOV R2, #2				; Move 2 para R2
	CMP R1, #0				; Testa se está no fim da lista
	BEQ SortingTime			; Se Z=1 pula para a função, se não ainda faltam números a serem adicionados à lista de primos
	
PrimeIteration
	MOV R0, #2				; gera uma constante de valor 2
	UDIV R0, R1, R0 		; armazena em r0 o valor do número verificado pela constante 2
	CMP R2, R0				; Compara o valor de r2 (valor da iteração) com r0 (metade do número verificado)
	BEQ PrimeDefine			; Se Z=1 pula para função
	UDIV R3, R1, R2			; Divide R1 por R2 e guarda o resultado em R3
	MLS R4, R2, R3, R1		; Esta operação indicará se a anterior possuia resto e guarda o resultado em R4
	CMP R4, #0				; Compara R4 a 0
	BEQ CarregarPrimo		; Se z=1 cai para a função
	ADD R2, #1				; Incrementa 1 ao valor de R2
	B PrimeIteration		; Vai para o início da função
	
PrimeDefine
	STRB R1, [R10], #1		; Armazena o valor de R1 no endereço de R10 e incrementa 1 em R10
	B CarregarPrimo			; Vai para a função
	
;---------------------
; FUNÇÃO BUBBLE SORT -
;---------------------

SortingTime
	MOV R5, #0				; Move 0 para R5
	LDR R6, =PRIMERAMNUM	; Ponteiro para o endereço
	LDR R7, =PRIMERAMNUM+1	; Ponteiro para o endereço seguinte
	
BubbleSort
	LDRB R8, [R6]			; Carrega o valor do endereço em R6 para R8
	LDRB R1, [R7]			; Carrega o valor do endereço em R1 para R7
	CMP R1, #0				; Testa se é o fim da lista
	BEQ FinishSort			; Se z=1 vai para a função
	CMP R1, R8
	;UDIV R0, R1, R8		; Divide R1 por R8 e guarda em R0
	;CMP R0, #1				; Compara R0 com 1
	BMI Sort				; Se N!=V vai para a função
	ADD R6, #1				; Incrementa 1 em R6
	ADD R7, #1				; Incrementa 1 em R7
	B BubbleSort			; Vai para a função
	
Sort
	ADD R5, #1				; Incrementa 1 em R5
	STRB R1, [R6], #1		; Armazena o valor de R1 no endereço de R6 e incrementa 1 em R6
	STRB R8, [R7], #1		; Armazena o valor de R8 no endereço de R7 e incrementa 1 em R7
	B BubbleSort			; Vai para a função
	
FinishSort
	CMP R5, #0				; Testa se a lista está ordenada
	BNE SortingTime			; Se não estiver retorna a função

;------------------
; FIM DO PROGRAMA -
;------------------

	NOP
	
ROMNUM DCB 193, 63, 176, 127, 43, 13, 211, 3, 203, 5, 21, 7, 206, 245, 157, 237, 241, 105, 252, 19

	ALIGN
	END