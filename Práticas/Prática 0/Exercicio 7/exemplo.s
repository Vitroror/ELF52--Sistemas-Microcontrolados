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
	mov r0, #10		;a) Mover para o R0 o valor 10;
	
Iteration
	add r0, r0, #5	;b) Somar R0 com 5 e colocar o resultado em R0;
	cmp r0, #50		;c) Enquanto a resposta n�o for 50 somar mais 5;
	bne Iteration
	bl Secondary	;redundante
	
Secondary			;d) Quando a resposta for 50 chamar uma fun��o que:
	mov r1, r0		;d.1) Copia o R0 para R1;
	cmp r1, #50		;d.2) Verifica se R1 � menor que 50;
	blt Iteration	;d.3) Se for menor que 50 incrementa, caso contr�rio modifica para -50
	neg r1, r1	
	
; Final do c�digo aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da se��o est� alinhada 
    END                         	;fim do arquivo