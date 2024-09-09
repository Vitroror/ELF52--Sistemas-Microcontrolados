;-----------------------------------------------------------------------------------------------------------
; ATIVIDADE PRÁTICA 1																					   -
; FEITO POR VICTOR AUGUSTO DEL MONEGO(2378345), THIAGO MELCHER ARMÊNIO(2358565) E MURILO CAPPONI(2358506)  -
;-----------------------------------------------------------------------------------------------------------

;--------------------------
;	"STARTUP" DO PROGRAMA -
;--------------------------

	AREA DATA, ALIGN=2
	AREA	|.text|, CODE, READONLY, ALIGN=2
	THUMB
	
	EXPORT Start
	IMPORT  GPIO_Init
    IMPORT  PortF_Output
    IMPORT  PortJ_Input
	IMPORT	PortN_Output
	IMPORT  PLL_Init
	IMPORT  SysTick_Init
	IMPORT  SysTick_Wait1ms
		
;-----------------------
;	INÍCIO DO PROGRAMA -
;-----------------------

Start 
	BL GPIO_Init ;inicia o gpio
	BL PLL_Init ;inicia o pll
	BL SysTick_Init ;inicia o system tick
	
	MOV R11, #2_0000 ;move o numero 0000 para o registrador R11
	MOV R12, #2_1000 ;move o numero 1000 para o registrador R12

	
	B Contador ;salta para a função contador

;A função aloca nos registradores o estado inicial de cada modo, e depois
;envia o PC para a função escolhida para ser o modo inicial.
	
;-----------------------
;	LOOPS PRINCIPAIS   -
;-----------------------

Cavaleiro
	BL SeletorFrequencia ;pula para a flag seletorfrequencia e salva o link register 
	MOV R11, #2_0000 ;move o numero 0000 para o registrador r11
 	BL SysTick_Wait1ms ;salta para a funçao com o numero de r0 sendo a quantidade de milisegundos a esperar
	BL VerificaLedsCV ;pula para a flag VerificaLedsCV e salva o link register
	BL PortJ_Input ;pula para a flag PortJ_Input e salva o link register
	CMP R2, #2_00000010 ;compara o valor do registrador R2 com o numero 00000010 e atualiza os flags
	BEQ Contador ;se igual, salta para a função Contador
	LSR R12, R12, #1 ;faz um deslocamento logico de 1 bit para a direita no R12
	CMP R12, #2_0001 ;compara o valor do R12 com o numero 0001
	BEQ CavaleiroBack ;se igual, salta para a função CavaleiroBack
 	B Cavaleiro ;salta para a função cavaleiro

;A função é o passo do cavaleiro feito em 4 bits. o bit 1 salta para a direita a cada iteração.
;Quando o bit percorre toda a palavra, o programa verifica o fato e transporta o PC para o retorno, na função CavaleiroBack

CavaleiroBack
	BL SeletorFrequencia ;pula para a flag seletorfrequencia e salva o link register
	BL SysTick_Wait1ms ;salta para a funçao com o numero de r0 sendo a quantidade de milisegundos a esperar
	BL VerificaLedsCV ;pula para a flag VerificaLedsCV e salva o link register
	BL PortJ_Input ;pula para a flag PortJ_Input e salva o link register
	CMP R2, #2_00000010 ;compara o valor do registrador R2 com o numero 00000010 e atualiza os flags
	BEQ Contador ;se igual, salta para a função Contador
	LSL R12, R12, #1 ;faz um deslocamento logico de 1 bit para a esquerda no R12
	CMP R12, #2_1000 ;compara o valor do R12 com o numero 1000
	BEQ Cavaleiro ;se igual, salta para a função Cavaleiro
	B CavaleiroBack ;salta para a função CavaleiroBack

;A função faz o contrário da função Cavaleiro, sendo que o bit se encontra no espaço menos significativo
;e salta para a esquerda para cara iteração. Ao chegar na posição mais significativa, o programa verifica
;e transporta o PC para a função Cavaleiro. Em ambas as funções, Caso a subrotina PortJ_Input reconheça que o botão J1 foi apertado,
;o PC salta para a função Contador.
	
Contador
	BL SeletorFrequencia ;pula para a flag seletorfrequencia e salva o link register
	MOV R12, #2_1000 ;move o numero 1000 para o registrador R12
	BL SysTick_Wait1ms ;salta para a funçao com o numero de r0 sendo a quantidade de milisegundos a esperar
	BL VerificaLedsCT ;pula para a flag VerificaLedsCT e salva o link register
	BL PortJ_Input ;pula para a flag PortJ_Input e salva o link register
	CMP R2, #2_00000010 ;compara o valor de R2 com o numero 00000010
	BEQ Cavaleiro ;se igual, salta para a função Cavaleiro
	ADD R11, #1 ;adiciona 1 ao valor contido no registrador R11
	CMP R11, #2_10000 ;comapra o valor contido no registrador R11 ao número 10000
	BNE Contador ;Se o valor nao for igual, salta para a função Contador
	MOV R11, #2_0 ;Move o valor 0 para o registrador R11
	BL Contador ;pula para a flag Contador e salva o link register

;A função se comporta como um contador 4 bits tradicional, quando chega em 1111, o contador reinicia, e o loop permanece.
;Caso a subrotina PortJ_Input reconheça que o botão J1 foi apertado, o PC salta para a função Contador.

;--------------------------------------
;	FUNÇÃO PARA SELECIONAR FREQUÊNCIA -
;--------------------------------------

SeletorFrequencia
	PUSH {LR} ;empurra o linkregister para dentro da pilha
	BL PortJ_Input ;pula para a flag PortJ_Input e salva o link register
	CMP R2, #2_00000001 ;compara o valor de R2 com o numero 00000001
	ADDEQ R9, R9, #1 ;se o valor for igual, incrementar em 1 o valor do registrador R9
	
	CMP R9, #0 ;compara o valor do registrador R9 com o valor 0
	MOVEQ R0, #1000 ;se igual, move o valor 1000 para o registrador R0
	
	CMP R9, #1 ;compara o valor de R9 com o numero 1
	MOVEQ R0, #500 ;se igual, move o numero 500 para o registrador R0
	
	CMP R9, #2 ;compara o valor de R9 com o numero 2
	MOVEQ R0, #200 ;se igual, move o numero 200 para o registrador R0
	
	CMP R9, #3 ;compara o valor de R9 com o numero 3
	MOVEQ R9, #0 ;se igual, move o numero 0 para o registrador R9
	MOVEQ R0, #1000 ;se igual, move o numero 1000 para o registrador R0
	POP {LR} ;retira o valor do linkregister da pilha
	BX LR ;retorna para o linkregister

;A função seleciona a frequência de oscilação dos LEDS, ou seja, o "tempo" (definido por R0) em que
;o programa aguarda. Em outras palavras, R0 representa quantas vezes o programa ira aguardar 1ms.


;------------------------------------------------
;	FUNÇÕES PARA VERIFICAR ACENDIMENTO DOS LEDS -
;------------------------------------------------

VerificaLedsCV
	PUSH{LR} ;empurra o linkregister para dentro da pilha
	CMP R12, #2_1000 ;compara o valor de R12 com o numero 1000
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00010 ;se igual, move o numero 00010 para o registrador R7
	MOVEQ R8, #2_00000 ;se igual, move o numero 00000 para o registrador R8
	
	CMP R12, #2_0100 ;compara o valor de R12 com o numero 0100
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00001 ;se igual, move o numero 00001 para o registrador R7
	MOVEQ R8, #2_00000 ;se igual, move o numero 00000 para o registrador R8
	
	CMP R12, #2_0010 ;compara o valor de R12 com o numero 0010
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00000 ;se igual, move o numero 00000 para o registrador R7
	MOVEQ R8, #2_10000 ;se igual, move o numero 10000 para o registrador R8
	
	CMP R12, #2_0001 ;compara o valor de R12 com o numero 0001
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00000 ;se igual, move o numero 00000 para o registrador R7
	MOVEQ R8, #2_00001 ;se igual, move o numero 00001 para o registrador R8
	
	BL PortN_Output ;pula para a flag PortN_Output e salva o link register
	BL PortF_Output ;pula para a flag PortF_Output e salva o link register
	POP {LR} ;retira o valor do linkregister da pilha
	BX LR ;retorna para o linkregister

;A função "traduz" a posição do bit no padrão de acendimento de leds respectivo. Ou seja, o programa irá verificar qual é
;o valor em R12, e dependendo de qual seja o valor (Ex. 1000, 0100, 0010, 0001), irá realizar o processo para acender e apagar o
;padrão de leds de acordo com como elas devem aparecer na placa, utilizando as subrotinas PortN_Output e PortF_Output.
	
VerificaLedsCT
	PUSH {LR} ;empurra o linkregister para dentro da pilha
	CMP R11, #2_0000 ;compara o valor de R11 com o numero 0000
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00000 ;se igual, move o numero 00000 para o registrador R7
	MOVEQ R8, #2_00000 ;se igual, move o numero 00000 para o registrador R8

	CMP R11, #2_0001 ;compara o valor de R11 com o numero 0001
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00000 ;se igual, move o numero 00000 para o registrador R7
	MOVEQ R8, #2_00001 ;se igual, move o numero 00001 para o registrador R8

	CMP R11, #2_0010 ;compara o valor de R11 com o numero 0010
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00000 ;se igual, move o numero 00000 para o registrador R7
	MOVEQ R8, #2_10000 ;se igual, move o numero 10000 para o registrador R8

	CMP R11, #2_0011 ;compara o valor de R11 com o numero 0011
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00000 ;se igual, move o numero 00000 para o registrador R7
	MOVEQ R8, #2_10001 ;se igual, move o numero 10001 para o registrador R8

	CMP R11, #2_0100 ;compara o valor de R11 com o numero 0100
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00001 ;se igual, move o numero 00001 para o registrador R7
	MOVEQ R8, #2_00000 ;se igual, move o numero 00000 para o registrador R8

	CMP R11, #2_0101 ;compara o valor de R11 com o numero 0101
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00001 ;se igual, move o numero 00001 para o registrador R7
	MOVEQ R8, #2_00001 ;se igual, move o numero 00001 para o registrador R8

	CMP R11, #2_0110 ;compara o valor de R11 com o numero 0110
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00001 ;se igual, move o numero 00001 para o registrador R7
	MOVEQ R8, #2_10000 ;se igual, move o numero 10000 para o registrador R8

	CMP R11, #2_0111 ;compara o valor de R11 com o numero 0111
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00001 ;se igual, move o numero 00001 para o registrador R7
	MOVEQ R8, #2_10001 ;se igual, move o numero 10001 para o registrador R8

	CMP R11, #2_1000 ;compara o valor de R11 com o numero 1000
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00010 ;se igual, move o numero 00010 para o registrador R7
	MOVEQ R8, #2_00000 ;se igual, move o numero 00000 para o registrador R8

	CMP R11, #2_1001 ;compara o valor de R11 com o numero 1001
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00010 ;se igual, move o numero 00010 para o registrador R7
	MOVEQ R8, #2_00001 ;se igual, move o numero 00001 para o registrador R8

	CMP R11, #2_1010 ;compara o valor de R11 com o numero 1010
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00010 ;se igual, move o numero 00010 para o registrador R7
	MOVEQ R8, #2_10000 ;se igual, move o numero 10000 para o registrador R8

	CMP R11, #2_1011 ;compara o valor de R11 com o numero 1011
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00010 ;se igual, move o numero 00010 para o registrador R7
	MOVEQ R8, #2_10001 ;se igual, move o numero 10001 para o registrador R8

	CMP R11, #2_1100 ;compara o valor de R11 com o numero 1100
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00011 ;se igual, move o numero 00011 para o registrador R7
	MOVEQ R8, #2_00000 ;se igual, move o numero 00000 para o registrador R8

	CMP R11, #2_1101 ;compara o valor de R11 com o numero 1101
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00011 ;se igual, move o numero 00011 para o registrador R7
	MOVEQ R8, #2_00001 ;se igual, move o numero 00001 para o registrador R8

	CMP R11, #2_1110 ;compara o valor de R11 com o numero 1110
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00011 ;se igual, move o numero 00011 para o registrador R7
	MOVEQ R8, #2_10000 ;se igual, move o numero 10000 para o registrador R8

	CMP R11, #2_1111 ;compara o valor de R11 com o numero 1111
	ITT EQ ;se igual, entao executar os seguintes comandos:
	MOVEQ R7, #2_00011 ;se igual, move o numero 00011 para o registrador R7
	MOVEQ R8, #2_10001 ;se igual, move o numero 10001 para o registrador R8

	BL PortN_Output ;pula para a flag PortN_Output e salva o link register
	BL PortF_Output ;pula para a flag PortF_Output e salva o link register
	POP{LR} ;retira o valor do linkregister da pilha
	BX LR ;retorna para o linkregister
	
;A função "traduz" a posição do bit no padrão de acendimento de leds respectivo. Ou seja, o programa irá verificar qual é
;o valor em R12, e dependendo de qual seja o valor (Ex. 1000, 0100, 0010, 0001), irá realizar o processo para acender e apagar o
;padrão de leds de acordo com como elas devem aparecer na placa, utilizando as subrotinas PortN_Output e PortF_Output.
	
	ALIGN
	END