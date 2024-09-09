; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Esquele de um novo Projeto para Keil
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
; Declarações EQU
LISTNUM EQU 0x20000400		
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
DeclareVectors
	ldr r12, =ROMNUMBER		;registra em r12 o endereço de memória da ROM
	ldr r11, =LISTNUM	 	;registra em r11 o endereço de memória da RAM
	mov r5, #0				;registra o numero 0 no registrador r5
	
StoreInRAM
	ldr r8, [r12]			;carrega em r8 o valor presente no endereço da ROM
	str r8, [r11]			;armazena r8 no endereço de memoria RAM
	
FactorialPreLoad
	ldr r4, [r11]			;carrega em r4 o valor registrado na RAM
	mov r0, #1				;move o número 1 para r0
	
FactorialMain
	add r5, r5, #1			;adiciona 1 ao valor em r5
	mul r0, r0, r5			;multiplica r0 por r5, e sobreescreve o resultado em r0
	cmp r5, r4				;compara r5 com r4
	bne FactorialMain		;caso o valor não seja igual (flag z não seja igual a 1), retorna para o inicio da subrotina
	
	;Função StoreInRAM : Essa função serve para armazenar o valor que está salvo na ROM no ambiente da RAM.
	;Estamos lendo o valor da ROM e colocando em algum lugar onde possamos manipula-lo.
	
	;Função FactorialPreLoad : Essa função serve para pré-carregar o valor salvo na RAM da ROM em um registrador
	;separado, para servir como referência, e também criar o valor 1 para validar a primeira multiplicação do fatorial.
	
	;Função FactorialMain : Essa função executa a operação do fatorial. Em um fatorial, fazemos uma multiplicação sequencial.
	;Por exemplo, 5! = 5 * 4 * 3 * 2 * 1 = 1 * 2 * 3 * 4 * 5. O registrador r5 representa a iteração, e será incrementado em 1
	;a cada loop. Após isso, r5 se multiplicará com r0 e se sobreescreverá. Dessa forma, todos os fatoriais começam com 1 vezes 1.
	;No fim do loop, r5 será comparado com r4, que é a referência. Se ambos forem iguais, isso quer dizer que o numero foi
	;multiplicado pelo ultimo valor necessário para completar o fatorial. Caso contrário, o loop reinicia. A inteção de comparar
	;r5 com outro registrador de referencia é feita para universalizar o código, de forma que o loop e as multiplicações sejam 
	;feitas repetidamente, até o fatorial ser completo, para todo e qualquer número que possa estar armazenado na ROM.
	
; Final do código aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da seção está alinhada
ROMNUMBER DCB 5		
    END                         	;fim do arquivo
		
