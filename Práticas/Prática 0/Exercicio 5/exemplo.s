; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Esquele de um novo Projeto para Keil
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
; Declara��es EQU
; <NOME>	EQU <VALOR>
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
	mov r0, #10			;a) Mova o valor 10 para o registrador R0;
	
	cmp r0, #9			;b) Teste se o registrador � maior ou igual que 9;
	
	ITTE ge				;c) Crie um bloco com If-Then com 3 execu��es condicionais
	movge r1, #50		;- Se sim, salve o n�mero 50 no R1
	addge r2, r1, #32	;- Se sim, adicione 32 com o R1 e salve o resultado em R2
	movlt r3, #75		;- Se n�o, salve o n�mero 75 no R3

	
	
	cmp r0, #11			;d) Agora verifique se o registrador � maior ou igual a 11 e execute 
	ITTE ge				;novamente o passo (c)
	movge r1, #50
	addge r2, r1, #32
	movlt r3, #75
	
	
	


; Final do c�digo aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da se��o est� alinhada 
    END                         	;fim do arquivo