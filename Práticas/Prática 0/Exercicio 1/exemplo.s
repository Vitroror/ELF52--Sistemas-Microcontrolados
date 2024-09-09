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
	mov r0, #65				;a) Salvar no registrador R0 o valor 65 decimal
	mov r1, #0x1B001B00		;b) Salvar no registrador R1 o valor 0x1B00.1B00
	mov r2, #0x5678			;c) Salvar no registrador R2 o valor 0x1234.5678
	movt r2, #0x1234		
	
	mov r3, #0x0040			;d) Guardar na posi��o de mem�ria 0x2000.0040 o valor de R0
	movt r3, #0x2000
	str r0, [r3]
	
	mov r4, #0x0044			;e) Guardar na posi��o de mem�ria 0x2000.0044 o valor de R1
	movt r4, #0x2000
	str r1, [r4]
	
	mov r5, #0x0048			;f) Guardar na posi��o de mem�ria 0x2000.0048 o valor de R2
	movt r5, #0x2000
	str r2, [r5]
	
	mov r6, #0x0001			;g) Guardar na posi��o de mem�ria 0x2000.004C o n�mero 0xF0001
	movt r6, #0x000F
	mov r7, #0x004C
	movt r7, #0x2000
	str r6, [r7]
	
	mov r8, #0xCD			;h) Guardar na posi��o de mem�ria 0x2000.0046 o byte 0xCD, sem sobrescrever os outros bytes da WORD
	mov r9, #0x0046
	movt r9, #0x2000
	strb r8, [r9]
	
	ldr r10, [r3]			;i) Ler o conte�do da mem�ria cuja posi��o 0x2000.0040 e guardar no R7
	ldr r11, [r5]			;j) Ler o conte�do da mem�ria cuja posi��o 0x2000.0048 o guardar R8
	mov r12, r10			;k) Copiar para o R9 o conte�do de R7


; Final do c�digo aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da se��o est� alinhada 
    END                         	;fim do arquivo