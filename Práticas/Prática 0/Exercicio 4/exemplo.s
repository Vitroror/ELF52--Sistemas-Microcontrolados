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
	mov r0, #101		;a) Adicionar os n�meros 101 e 253 atualizando os flags;
	adds r1, r0, #253
	
	mov r2, #1500		;b) Adicionar os n�meros 1500 e 40543 sem atualizar os flags;
	mov r3, #40543
	add r4, r2, r3
	
	mov r5, #340		;c) Subtrair o n�mero 340 pelo n�mero 123 atualizando os flags;
	sub r6, r5, #123
	
	mov r7, #1000		;d) Subtrair o n�mero 1000 pelo n�mero 2000 atualizando os flags;
	sub r8, r7, #2000
	
	mov r9, #54378		;e)	Multiplicar o n�mero 54378 por 4;
	mov r10, #4
	mul r11, r9, r10
	
	mov r0, #0x3344		;f) Multiplicar com o resultado em 64 bits os n�meros 0x1122.3344 e 
	movt r0, #0x1122	;0x4433.2211;
	mov r1, #0x2211
	movt r1, #0x4433
	umull r2, r3, r0, r1
	
	mov r4, #0x7560		;g) Dividir o n�mero 0xFFFF.7560 por 1000 com sinal;
	movt r4, #0xFFFF
	mov r5, #1000
	sdiv r6, r0, r1
	
	udiv r7, r0, r1		;h) Dividir o n�mero 0xFFFF.7560 por 1000 sem sinal;
	
	

; Final do c�digo aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da se��o est� alinhada 
    END                         	;fim do arquivo