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
	mov r0, #701		; Realizar o deslocamento lógico em 5 bits do número 701 para a direita com 
	lsls r1, r0, #5		;o flag ‘S’;
	
	
	mov r2, #32067		;b) Realizar o deslocamento lógico em 4 bits do número -32067 para a direita 
	neg r5, r2			;com o flag ‘S’ (Usar o MOV para o número positivo e depois NEG para 
	lsrs r3, r5, #4		;negativar)
	
	
	asrs r4, r0, #3		;c)Realizar o deslocamento aritmético em 3 bits do número 701 para a direita 
						;com o flag ‘S’;


	asrs r6, r5, #5		;d) Realizar o deslocamento aritmético em 5 bits do número -32067 para a 
						;direita com o flag ‘S’;

	
	mov r0, #255		;e) Realizar o deslocamento lógico em 8 bits do número 255 para a esquerda 
	lsls r1, r0, #8		;com o flag ‘S’;

	
	
	mov r2, #58982		;f) Realizar o deslocamento lógico em 18 bits do número -58982 para a 
	neg r3, r2			;esquerda com o flag ‘S’;
	lsls r4, r3, #18
	
	
	mov r0, #0x1234		;g) Rotacionar em 10 bits o número 0xFABC.1234;
	movt r0, #0xFABC
	ror r1, r0, #10
	
	mov r2, #0x4321		;h) Rotacionar em 2 bits com o carry o número 0x0000.4321; (Realizar duas 
	rrx r3, r2			;vezes)
	rrx r4, r3
	
	
	


; Final do código aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo