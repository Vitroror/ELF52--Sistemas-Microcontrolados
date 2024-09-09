;-----------------------------------------------------------------------------------------------------------
; controlesemaforo.s																				  	   -
; FEITO POR VICTOR AUGUSTO DEL MONEGO(2378345), THIAGO MELCHER ARMÊNIO(2358565) E MURILO CAPPONI(2358506)  -
;-----------------------------------------------------------------------------------------------------------

	AREA DATA, ALIGN=2
	AREA	|.text|, CODE, READONLY, ALIGN=2
	THUMB

	IMPORT SysTick_Wait1ms		; função para esperar
	IMPORT PortF_Output			; output do port F
	IMPORT PortN_Output			; output do port N
	
	EXPORT WaitFor
	EXPORT Semaforo

Semaforo
	MOV		R10, LR
	LDR 	R5, =Sem_F			;vetor de estados de F. Explicado no fim do código
	LDR 	R6, =Sem_N			;vetor de estados de N. Explicado no fim do código	
	LDR 	R0, [R5, R8]		;seleciona o estado de F
	BL		PortF_Output		;print do estado de F
	LDR 	R0, [R6, R8]		;seleciona o estado de N
	BL		PortN_Output		;print do estado de N
	BL		WaitFor
	CMP 	R8, #5				;verifica se chega no estado 5(ultimo) 
	ADDNE	R8, R8, #1			;se não, passa para o proximo estado
	MOVEQ	R8, #0				;se sim, retorna para o primeiro estado
	BX 		R10					;retorna para o loop principal
	
WaitFor
	MOV		R9, LR				;armazenando Link Register no R9
	CMP		R8, #0				;verifica se o semáforo esta no estado inicial
	BLEQ	PedestrianCheck		;verifica o flag de pedestre
	CMP		R8, #0				;verifica se a maquina esta no estado 0
	BLEQ 	SysTick_Wait1ms		;aguarda
	BXEQ	R9					;volta para o link register
	CMP		R8, #1				;verifica se a maquina está no estado 1
	MOVEQ	R0, #6000			;configura uma espera de 6 segundos
	BLEQ 	SysTick_Wait1ms		;aguarda
	BXEQ	R9					;retorna ao link register
	CMP		R8, #2				;verifica se a maquina esta no estado 2
	MOVEQ	R0, #2000			;configura uma espera de 2 segundos
	BLEQ 	SysTick_Wait1ms		;aguarda
	BXEQ	R9					;retorna ao link register
	CMP		R8, #3				;verifica se a maquina está no estado 3
	MOVEQ	R0, #1000			;configura uma espera de 1 segundo
	BLEQ 	SysTick_Wait1ms		;aguarda
	BXEQ	R9					;retorna ao link register
	CMP		R8, #4				;verifica se a maquina está no estado 4
	MOVEQ	R0, #6000			;configura uma espera de 6 segundos
	BLEQ 	SysTick_Wait1ms		;aguarda
	BXEQ	R9					;retorna ao link register
	CMP		R8, #5				;verifica se a maquina está no estado 5
	MOVEQ	R0, #2000			;configura uma espera de 2 segundos
	BLEQ 	SysTick_Wait1ms		;aguarda
	BXEQ	R9					;retorna ao link register
	
PedestrianCheck
	PUSH	{LR}				;guarda o link register
	CMP		R11,#0				;verifica o flag de pedestre
	MOVEQ	R0, #1000			;espera 1 segundo
	BXEQ	LR					;retorna ao link register
	MOV		R7, #0				
	
PedestrianLEDBlinker			;basicamente um passo do cavaleiro
	MOV		R0, #2_0000010		;acende o led 1	
	BL		PortN_Output		
	MOV		R0, #2_00000000		;apaga os leds 3 e 4
	BL		PortF_Output
	MOV		R0, #1000			;espera 1 segundo
	BL		SysTick_Wait1ms
	MOV		R0, #2_0000001		;acende o led 2
	BL 		PortN_Output
	MOV		R0, #1000			;espera 1 segundo
	BL		SysTick_Wait1ms
	MOV		R0, #2_00000000		;apaga os leds 1 ou 2
	BL 		PortN_Output
	MOV		R0, #2_00010000		;acende o led 3
	BL		PortF_Output
	MOV		R0, #1000			;espera 1 segundo
	BL	 	SysTick_Wait1ms
	MOV		R0, #2_00000001		;acende o led 4
	BL		PortF_Output
	MOV		R0, #2000			;espera 2 segundos
	BL		SysTick_Wait1ms
	MOV		R0, #0				;reseta a espera
	MOV		R11, #0				;reseta a interrupção
	POP	{LR}
	BX	LR						;fim da função
	
	
    ALIGN                   ;Garante que o fim da seção está alinhada 
		
Sem_N	DCB		2_00000011,2_00000011,2_00000011,2_00000011,2_00000010,2_00000001	;este vetor guarda os estados de dados do Port N
Sem_F	DCB		2_00010001,2_00010000,2_00000001,2_00010001,2_00010001,2_00010001	;este vetor guarda os estados de dados do Port F

    END                     ;Fim do arquivo