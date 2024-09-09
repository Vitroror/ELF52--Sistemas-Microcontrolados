; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Esquele de um novo Projeto para Keil
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
; Declara��es EQU
LISTNUM EQU 0x20000400		
;################################################################################
	AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB
; Se alguma fun��o do arquivo for chamada em outro arquivo	
    EXPORT Start					; Permite chamar a fun��o Start a partir de 
									; outro arquivo. No caso startup.s
								
; Se chamar alguma fun��o externa	
;	IMPORT <func>          			; Permite chamar dentro deste arquivo uma 
									; fun��o <func>

;################################################################################
; Fun��o main()
Start								;Label Start ... void main(void)
; Comece o c�digo aqui <=========================================================
DeclareVectors
	ldr r12, =ROMNUMBER		;registra em r12 o endere�o de mem�ria da ROM
	ldr r11, =LISTNUM	 	;registra em r11 o endere�o de mem�ria da RAM
	mov r5, #0				;registra o numero 0 no registrador r5
	
StoreInRAM
	ldr r8, [r12]			;carrega em r8 o valor presente no endere�o da ROM
	str r8, [r11]			;armazena r8 no endere�o de memoria RAM
	
FactorialPreLoad
	ldr r4, [r11]			;carrega em r4 o valor registrado na RAM
	mov r0, #1				;move o n�mero 1 para r0
	
FactorialMain
	add r5, r5, #1			;adiciona 1 ao valor em r5
	mul r0, r0, r5			;multiplica r0 por r5, e sobreescreve o resultado em r0
	cmp r5, r4				;compara r5 com r4
	bne FactorialMain		;caso o valor n�o seja igual (flag z n�o seja igual a 1), retorna para o inicio da subrotina
	
	;Fun��o StoreInRAM : Essa fun��o serve para armazenar o valor que est� salvo na ROM no ambiente da RAM.
	;Estamos lendo o valor da ROM e colocando em algum lugar onde possamos manipula-lo.
	
	;Fun��o FactorialPreLoad : Essa fun��o serve para pr�-carregar o valor salvo na RAM da ROM em um registrador
	;separado, para servir como refer�ncia, e tamb�m criar o valor 1 para validar a primeira multiplica��o do fatorial.
	
	;Fun��o FactorialMain : Essa fun��o executa a opera��o do fatorial. Em um fatorial, fazemos uma multiplica��o sequencial.
	;Por exemplo, 5! = 5 * 4 * 3 * 2 * 1 = 1 * 2 * 3 * 4 * 5. O registrador r5 representa a itera��o, e ser� incrementado em 1
	;a cada loop. Ap�s isso, r5 se multiplicar� com r0 e se sobreescrever�. Dessa forma, todos os fatoriais come�am com 1 vezes 1.
	;No fim do loop, r5 ser� comparado com r4, que � a refer�ncia. Se ambos forem iguais, isso quer dizer que o numero foi
	;multiplicado pelo ultimo valor necess�rio para completar o fatorial. Caso contr�rio, o loop reinicia. A inte��o de comparar
	;r5 com outro registrador de referencia � feita para universalizar o c�digo, de forma que o loop e as multiplica��es sejam 
	;feitas repetidamente, at� o fatorial ser completo, para todo e qualquer n�mero que possa estar armazenado na ROM.
	
; Final do c�digo aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da se��o est� alinhada
ROMNUMBER DCB 5		
    END                         	;fim do arquivo
		
