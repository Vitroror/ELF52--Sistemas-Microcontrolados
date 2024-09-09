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
	mov r12, #0xF0				;a) Realizar a opera��o l�gica AND do valor 0xF0 com o valor bin�rio 
	ands r0, r12, #2_01010101	;01010101 e salvar o resultado em R0. Utilizar o sufixo �S� para atualizar 
								;os flags

	mov r11,  #2_11001100		;b) Realizar a opera��o l�gica AND do valor 11001100 bin�rio com o valor 
	ands r1, r11, #2_00110011	;bin�rio 00110011 e salvar o resultado em R1. Utilizar o sufixo �S� para 
								;atualizar os flags
	
	
	mov r10, #2_10000000		;c) Realizar a opera��o l�gica OR do valor 10000000 bin�rio com o valor 
	orrs r2, r10, #2_00110111	;bin�rio 00110111 e salvar o resultado em R2. Utilizar o sufixo �S� para 
								;atualizar os flags
	
	
	mov r9, #0xABCD				;d)Realizar a opera��o l�gica AND do valor 0xABCDABCD com o valor 
	movt r9, #0xABCD			;0xFFFF0000 (sem usar LDR-diretiva) e salvar o resultado em R3. Utilizar 
	mov r8, #0xFFFF				;o sufixo �S� para atualizar os flags. Utilizar a instru��o BIC;
	bics r3, r9, r8
	
	
	
	
	
	
	
	


; Final do c�digo aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da se��o est� alinhada 
    END                         	;fim do arquivo