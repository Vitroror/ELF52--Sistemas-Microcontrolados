;-----------------------------------------------------------------------------------------------------------
; ATIVIDADE PRÁTICA 1																				   -
; FEITO POR VICTOR AUGUSTO DEL MONEGO(2378345), THIAGO MELCHER ARMÊNIO(2358565) E MURILO CAPPONI(2358506)  -
;-----------------------------------------------------------------------------------------------------------

;--------------------------
;	"STARTUP" DO PROGRAMA -
;--------------------------

	AREA DATA, ALIGN=2
	AREA	|.text|, CODE, READONLY, ALIGN=2
	THUMB
	
	EXPORT Start
	IMPORT PLL_Init
	IMPORT SysTick_Init
	IMPORT GPIO_Init
	IMPORT SysTick_Wait1ms
	IMPORT Semaforo
		
;-----------------------
;	INÍCIO DO PROGRAMA -
;-----------------------
Start
	BL PLL_Init
	BL GPIO_Init
	BL SysTick_Init
	
	MOV		R8, #0				;Estado do semáforo
	MOV		R9, #0				;Guarda Link Register
	MOV		R10, #0				;Guarda Link Register
	MOV		R11, #0				;Verifica botão de pedestres
	
MainLoop

	BL Semaforo					;viaja para o loop de semáforo		
	B MainLoop					;mantém o loop principal
	
	ALIGN
	END