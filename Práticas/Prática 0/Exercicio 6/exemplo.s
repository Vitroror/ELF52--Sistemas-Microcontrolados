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
	mov r0, #10		;a) Mover o valor 10 para o registrador R0;

	
	mov r1, #0xCC12	;b) Mover o valor 0xFF11.CC22 para o registrador R1;
	movt r1, #0xFF11
	
	mov r2, #1234	;c) Mover o valor 1234 para o registrador R2;
	
	mov r3, #0x300	;d) Mover o valor 0x300 para o registrador R3;
	
	push {r0}		;e) Empurrar para a pilha o R0;
	
	push {r1-r3}	;f) Empurrar para a pilha os R1, R2 e R3;
	
	mov r10, r13	;g) Visualizar a pilha na memória (o topo da pilha está em 0x2000.0400);
	
	mov r1, #60		;h) Mover o valor 60 para o registrador R1;
	mov r2, #0x1234	;i) Mover o valor 0x1234 para o registrador R2;

	pop{r1-r3}		;j) Desempilhar corretamente os valores para os registradores R0, R1, R2 e R3;
	pop{r0}
	
	
	
	
	
	
	

	


; Final do código aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo