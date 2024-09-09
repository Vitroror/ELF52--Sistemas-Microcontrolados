;-----------------------------------------------------------------------------------------------------------
; ATIVIDADE PR�TICA 1																					   -
; FEITO POR VICTOR AUGUSTO DEL MONEGO(2378345), THIAGO MELCHER ARM�NIO(2358565) E MURILO CAPPONI(2358506)  -
;-----------------------------------------------------------------------------------------------------------

;--------------------------
;	"STARTUP" DO PROGRAMA -
;--------------------------

	AREA DATA, ALIGN=2
	AREA	|.text|, CODE, READONLY, ALIGN=2
	THUMB
	
	EXPORT Start
	IMPORT  GPIO_Init
    IMPORT  PortJ_Input
	IMPORT	PortN_Output
		
;-----------------------
;	IN�CIO DO PROGRAMA -
;-----------------------

Start  			
	BL		GPIO_Init	;pula para a flag GPIO_Init e salva o link register				

MainLoop
	CMP		R4, #1			;compara o valor do registrador R4 com o numero 1 e atualiza os flags					
	BEQ		IRQAtivada		;se igual, salta para a fun��o IRQAtivada
	B		MainLoop		;salta para a fun��o MainLoop
	
IRQAtivada
	CMP		R5,#2			;compara o valor do registrador R5 com o numero 2 e atualiza os flags			
	BEQ		PrimeiroLed		;se igual, salta para a fun��o PrimeiroLed					
	CMP		R5,#3			;compara o valor do registrador R5 com o numero 3 e atualiza os flags 					
	BEQ		SegundoLed		;se igual, salta para a fun��o SegundoLed						
	B		MainLoop		;salta para a fun��o MainLoop
	
PrimeiroLed	
	MOV		R4,#0			;move o numero 0 para o registrador r4					
	MOV		R0,#2_10		;move o numero #2_10 para o registrador r0				
	BL		PortN_Output	;pula para a flag PortN_Output e salva o link register			
	B		MainLoop		;salta para a fun��o MainLoop
	
SegundoLed
	MOV		R4,#0			;move o numero 0 para o registrador r4						
	MOV		R0,#2_01		;move o numero #2_10 para o registrador r0				
	BL		PortN_Output	;pula para a flag PortN_Output e salva o link register			
	B		MainLoop		;salta para a fun��o MainLoop


    ALIGN                   ;Garante que o fim da se��o est� alinhada 
    END                     ;Fim do arquivo