; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Esquele de um novo Projeto para Keil
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
; Declarações EQU
; <NOME>	EQU <VALOR>
;################################################################################
	AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB
; Se alguma função do arquivo for chamada em outro arquivo	
    EXPORT Start					; Permite chamar a função Start a partir de 
									; outro arquivo. No caso startup.s
								
; Se chamar alguma função externa	
;	IMPORT <func>          			; Permite chamar dentro deste arquivo uma 
									; função <func>

;################################################################################
; Função main()
Start								;Label Start ... void main(void)
; Comece o código aqui <=========================================================
	mov r0, #101		;a) Adicionar os números 101 e 253 atualizando os flags;
	adds r1, r0, #253
	
	mov r2, #1500		;b) Adicionar os números 1500 e 40543 sem atualizar os flags;
	mov r3, #40543
	add r4, r2, r3
	
	mov r5, #340		;c) Subtrair o número 340 pelo número 123 atualizando os flags;
	sub r6, r5, #123
	
	mov r7, #1000		;d) Subtrair o número 1000 pelo número 2000 atualizando os flags;
	sub r8, r7, #2000
	
	mov r9, #54378		;e)	Multiplicar o número 54378 por 4;
	mov r10, #4
	mul r11, r9, r10
	
	mov r0, #0x3344		;f) Multiplicar com o resultado em 64 bits os números 0x1122.3344 e 
	movt r0, #0x1122	;0x4433.2211;
	mov r1, #0x2211
	movt r1, #0x4433
	umull r2, r3, r0, r1
	
	mov r4, #0x7560		;g) Dividir o número 0xFFFF.7560 por 1000 com sinal;
	movt r4, #0xFFFF
	mov r5, #1000
	sdiv r6, r0, r1
	
	udiv r7, r0, r1		;h) Dividir o número 0xFFFF.7560 por 1000 sem sinal;
	
	

; Final do código aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo