; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
        THUMB                        ; Instru��es do tipo Thumb-2
;################################################################################
; Defini��es de Valores
BIT0						EQU		2_0001
BIT1						EQU		2_0010
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 		EQU		0x400FE608
SYSCTL_PRGPIO_R		 		EQU		0x400FEA08
; NVIC
NVIC_EN1_R					EQU		0xE000E104
NVIC_PRI12_R		     	EQU		0xE000E430        
; Defini��es dos Ports - PORT J
GPIO_PORTJ_AHB_IS_R      	EQU		0x40060404
GPIO_PORTJ_AHB_IBE_R      	EQU		0x40060408
GPIO_PORTJ_AHB_IEV_R      	EQU		0x4006040C
GPIO_PORTJ_AHB_IM_R      	EQU		0x40060410
GPIO_PORTJ_AHB_RIS_R      	EQU		0x40060414
GPIO_PORTJ_AHB_ICR_R      	EQU		0x4006041C    
GPIO_PORTJ_AHB_LOCK_R    	EQU		0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU		0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU		0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU		0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU		0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU		0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU		0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU		0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU		0x400603FC
GPIO_PORTJ               	EQU		2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU		0x40064520
GPIO_PORTN_AHB_CR_R      	EQU		0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU		0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU		0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU		0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU		0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU		0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU		0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU		0x400643FC
GPIO_PORTN               	EQU		2_001000000000000
; Defini��es dos Registradores especiais do PORT F
GPIO_PORTF_LOCK_R    		EQU		0x4005D520
GPIO_PORTF_CR_R      		EQU		0x4005D524
GPIO_PORTF_AMSEL_R   		EQU		0x4005D528
GPIO_PORTF_PCTL_R    		EQU		0x4005D52C
GPIO_PORTF_DIR_R     		EQU		0x4005D400
GPIO_PORTF_AFSEL_R   		EQU		0x4005D420
GPIO_PORTF_DEN_R     		EQU		0x4005D51C
GPIO_PORTF_PUR_R     		EQU		0x4005D510	
GPIO_PORTF_DATA_R    		EQU		0x4005D3FC
GPIO_PORTF_DATA_BITS_R  	EQU		0x4005D000
GPIO_PORTF               	EQU		2_000000000100000	;datasheet pg 382 ...	

;################################################################################
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortN_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortF_Output			; Permite chamar PortF_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
        EXPORT GPIOPortJ_Handler    
        IMPORT EnableInterrupts
        IMPORT DisableInterrupts
									
;################################################################################
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
;################################################################################
GPIO_Init
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
; enable clock to GPIOF at clock gating register
	LDR     R0, =SYSCTL_RCGCGPIO_R  				;Carrega o endere�o do registrador RCGCGPIO
	MOV		R1, #GPIO_PORTN                 		;Seta o bit da porta N
	ORR     R1, #GPIO_PORTJ							;Seta o bit da porta J, fazendo com OR
	ORR     R1, #GPIO_PORTF						;Seta o bit da porta J, fazendo com OR
	STR     R1, [R0]								;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
	LDR     R0, =SYSCTL_PRGPIO_R					;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO
	LDR     R1, [R0]								;L� da mem�ria o conte�do do endere�o do registrador
	MOV     R2, #GPIO_PORTN                 		;Seta os bits correspondentes �s portas para fazer a compara��o
	ORR     R2, #GPIO_PORTJ                 		;Seta o bit da porta J, fazendo com OR
    	ORR     R2, #GPIO_PORTF                 	;Seta o bit da porta J, fazendo com OR
	TST     R1, R2									;ANDS de R1 com R2
    BEQ     EsperaGPIO							    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando
; 2. Limpar o AMSEL para desabilitar a anal�gica
	MOV     R1, #0x00								;Colocar 0 no registrador para desabilitar a fun��o anal�gica
	LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     		;Carrega o R0 com o endere�o do AMSEL para a porta J
	STR     R1, [R0]								;Guarda no registrador AMSEL da porta J da mem�ria
	LDR     R0, =GPIO_PORTN_AHB_AMSEL_R				;Carrega o R0 com o endere�o do AMSEL para a porta N
	STR     R1, [R0]					    		;Guarda no registrador AMSEL da porta N da mem�ria
	LDR     R0, =GPIO_PORTF_AMSEL_R				;Carrega o R0 com o endere�o do AMSEL para a porta N
    	STR     R1, [R0]					    	;Guarda no registrador AMSEL da porta N da mem�ria
; 3. Limpar PCTL para selecionar o GPIO
	MOV     R1, #0x00					    		;Colocar 0 no registrador para selecionar o modo GPIO
	LDR     R0, =GPIO_PORTJ_AHB_PCTL_R				;Carrega o R0 com o endere�o do PCTL para a porta J
	STR     R1, [R0]                        		;Guarda no registrador PCTL da porta J da mem�ria
	LDR     R0, =GPIO_PORTN_AHB_PCTL_R      		;Carrega o R0 com o endere�o do PCTL para a porta N
	STR     R1, [R0]                        		;Guarda no registrador PCTL da porta N da mem�ria
	LDR     R0, =GPIO_PORTF_PCTL_R      		;Carrega o R0 com o endere�o do PCTL para a porta N
    	STR     R1, [R0]                        	;Guarda no registrador PCTL da porta N da mem�ria
; 4. DIR para 0 se for entrada, 1 se for sa�da
	LDR     R0, =GPIO_PORTN_AHB_DIR_R				;Carrega o R0 com o endere�o do DIR para a porta N
	MOV     R1, #BIT0								;PN1 & PN0 para LED
	ORR     R1, #BIT1      							;Enviar o valor 0x03 para habilitar os pinos como sa�da
	STR     R1, [R0]								;Guarda no registrador
	LDR     R0, =GPIO_PORTF_DIR_R				;Carrega o R0 com o endere�o do DIR para a porta N
	MOV     R1, #2_00010001						;PN1
    	STR     R1, [R0]							;Guarda no registrador
;O certo era verificar os outros bits da PJ para n�o transformar entradas em sa�das desnecess�rias
	LDR     R0, =GPIO_PORTJ_AHB_DIR_R				;Carrega o R0 com o endere�o do DIR para a porta J
	MOV     R1, #0x00               				;Colocar 0 no registrador DIR para funcionar com sa�da
	STR     R1, [R0]								;Guarda no registrador PCTL da porta J da mem�ria
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem fun��o alternativa
	MOV     R1, #0x00								;Colocar o valor 0 para n�o setar fun��o alternativa
	LDR     R0, =GPIO_PORTN_AHB_AFSEL_R				;Carrega o endere�o do AFSEL da porta N
	STR     R1, [R0]								;Escreve na porta
	LDR     R0, =GPIO_PORTF_AFSEL_R				;Carrega o endere�o do AFSEL da porta N
    	STR     R1, [R0]							;Escreve na porta
	LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     		;Carrega o endere�o do AFSEL da porta J
	STR     R1, [R0]                        		;Escreve na porta
; 6. Setar os bits de DEN para habilitar I/O digital
	LDR     R0, =GPIO_PORTN_AHB_DEN_R				;Carrega o endere�o do DEN
	LDR     R1, [R0]								;Ler da mem�ria o registrador GPIO_PORTN_AHB_DEN_R
	MOV     R2, #BIT0
	ORR     R2, #BIT1								;Habilitar funcionalidade digital na DEN os bits 0 e 1
	ORR     R1, R2
	STR     R1, [R0]								;Escreve no registrador da mem�ria funcionalidade digital 
	LDR     R0, =GPIO_PORTF_DEN_R		    		;Carrega o endere�o do DEN
    MOV     R1, #2_00010001                 			;N1
    STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
	LDR     R0, =GPIO_PORTJ_AHB_DEN_R				;Carrega o endere�o do DEN
	LDR     R1, [R0]                        		;Ler da mem�ria o registrador GPIO_PORTN_AHB_DEN_R
	MOV     R2, #BIT0                           
	ORR     R2, #BIT1			            		;Habilitar funcionalidade digital na DEN os bits 0 e 1
	ORR     R1, R2                              
	STR     R1, [R0]                        		;Escreve no registrador da mem�ria funcionalidade digital
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
	LDR     R0, =GPIO_PORTJ_AHB_PUR_R				;Carrega o endere�o do PUR para a porta J
	MOV     R1, #BIT0								;Habilitar funcionalidade digital de resistor de pull-up 
	ORR     R1, #BIT1								;nos bits 0 e 1
	STR     R1, [R0]								;Escreve no registrador da mem�ria do resistor de pull-up
;Interrup��es
; 8. Desabilitar a interrup��o no registrador IM
	LDR     R0, =GPIO_PORTJ_AHB_IM_R				;Carrega o endere�o do IM para a porta J
	MOV     R1, #2_00								;Desabilitar as interrup��es  
	STR     R1, [R0]								;Escreve no registrador
; 9. Configurar o tipo de interrup��o por borda no registrador IS
	LDR     R0, =GPIO_PORTJ_AHB_IS_R				;Carrega o endere�o do IS para a porta J
	MOV     R1, #2_01								;Por Borda  
	STR     R1, [R0]								;Escreve no registrador
; 10. Configurar  borda �nica no registrador IBE
	LDR     R0, =GPIO_PORTJ_AHB_IBE_R				;Carrega o endere�o do IBE para a porta J
	MOV     R1, #2_00								;Borda �nica  
	STR     R1, [R0]								;Escreve no registrador
; 11. Configurar  borda de descida (bot�o pressionado) no registrador IEV
	LDR     R0, =GPIO_PORTJ_AHB_IEV_R				;Carrega o endere�o do IEV para a porta J
	MOV     R1, #2_00								;Borda �nica Descida nos 2 bits 
	STR     R1, [R0]								;Escreve no registrador
; 12. Configurar  borda de descida (bot�o pressionado) no registrador IEV
	LDR     R0, =GPIO_PORTJ_AHB_IEV_R				;Carrega o endere�o do IEV para a porta J
	MOV     R1, #2_10								;Borda �nica Descida e Subida 
	STR     R1, [R0]								;Escreve no registrador    
; 13. Habilitar a interrup��o no registrador IM
	LDR     R0, =GPIO_PORTJ_AHB_IM_R				;Carrega o endere�o do IM para a porta J
	MOV     R1, #2_11								;Habilitar as interrup��es nos bit 0 e bit 1 
	STR     R1, [R0]								;Escreve no registrador
;Interrup��o n�mero 51            
; 14. Setar a prioridade no NVIC
	LDR     R0, =NVIC_PRI12_R           			;Carrega o do NVIC para o grupo que tem o J entre 51 e 48
	MOV     R1, #0xA0000000                 		;Prioridade 5							  
	STR     R1, [R0]								;Escreve no registrador da mem�ria
; 15. Habilitar a interrup��o no NVIC
	LDR     R0, =NVIC_EN1_R 	          			;Carrega o do NVIC para o grupo que tem o J entre 63 e 32
	MOV     R1, #0x80000                         
	STR     R1, [R0]								;Escreve no registrador da mem�ria
; 16. Habilitar a chave geral das interrup��es
	PUSH	{LR}
	BL		EnableInterrupts
	POP		{LR}
	BX      LR

;################################################################################
; Fun��o PortF_Output
; Par�metro de entrada: R0 --> se o BIT1 est� ligado ou desligado
; Par�metro de sa�da: N�o tem
;################################################################################
PortF_Output
	LDR	R1, =GPIO_PORTF_DATA_R		    		;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00010001                     	;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          	;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            	;Escreve na porta N o barramento de dados do pino N1
	BX LR										;Retorno

;################################################################################
; Fun��o PortN_Output
; Par�metro de entrada: R0 --> se os BIT1 e BIT0 est�o ligado ou desligado
; Par�metro de sa�da: N�o tem
;################################################################################
PortN_Output
	LDR		R1, =GPIO_PORTN_AHB_DATA_R		    	;Carrega o valor do offset do data register
													;Read-Modify-Write para escrita
	LDR		R2, [R1]
	BIC		R2, #2_00000011                     	;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111100
	ORR		R0, R0, R2                          	;Fazer o OR do lido pela porta com o par�metro de entrada
	STR		R0, [R1]                            	;Escreve na porta N o barramento de dados dos pinos [N5-N0]
	BX		LR										;Retorno

;################################################################################
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
;################################################################################
PortJ_Input
	LDR		R1, =GPIO_PORTJ_AHB_DATA_R	    		;Carrega o valor do offset do data register
	LDR		R0, [R1]                           		;L� no barramento de dados dos pinos [J1-J0]
	BX		LR										;Retorno


;################################################################################
; Fun��o ISR GPIOPortJ_Handler (Tratamento da interrup��o)
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R5 [J1-J0] e R4=flag de passagem pela interrup��o
;################################################################################
GPIOPortJ_Handler
	LDR		R1, =GPIO_PORTJ_AHB_DATA_R		    	;Carrega o valor do offset do data register
	LDR 	R5, [R1]                            	;R5 = L� no barramento de dados dos pinos [J1-J0]
    MOV		R11, #1									;Flag=1	
	LDR		R1, =GPIO_PORTJ_AHB_ICR_R				;Bdr descida e bit Bdr subida
    MOV		R0, #2_11        						;Fazendo o ACK do bit 0 ou do bit 1 do PortJ
    STR		R0, [R1]      							;limpando a interrup��o (ack)
    BX		LR             							;retorno
 
     
    ALIGN                           				; garante que o fim da se��o est� alinhada 
    END                             				; fim do arquivo  