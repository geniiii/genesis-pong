io_ctrl1: equ $A10009   ; 1P control port
io_ctrl2: equ $A1000B   ; 2P control port
io_data1: equ $A10003   ; 1P data port
io_data2: equ $A10005   ; 2P data port

Input_Init:
	; Z80_FastPause
	move.b #$40, io_ctrl1
	move.b #$40, io_data1
	move.b #$40, io_ctrl2
	move.b #$40, io_data2
	; Z80_Resume

Input_UpdateControllerPart: macro write, register
	move.b #write, (a0)
	nop
	nop
	move.b (a0), register
	endm

Input_Rearrange: macro reg1, reg2
	and.b   #$3F, reg1
	and.b   #$30, reg2
	add.b   reg2, reg2
	add.b   reg2, reg2
	or.b    reg2, reg1
	not.b   reg1
	endm

Input_UpdatePressed: macro reg, p
	move.b  input_p_held, d5
	move.b  reg, input_p_held
	not.b   d5
	and.b   d5, reg
	move.b  reg, input_p_press
	endm

; Trashes: a0, d4-d7
Input_Update:
	; Z80_FastPause

	lea io_data1, a0
	Input_UpdateControllerPart $40, d4
	Input_UpdateControllerPart $00, d5
	lea io_data2, a0
	Input_UpdateControllerPart $40, d6
	Input_UpdateControllerPart $00, d7

	; Z80_Resume

	; Rearrange bits into SACBRLDU
	Input_Rearrange d4, d5 ; Controller 1
	Input_Rearrange d6, d7 ; Controller 2

	Input_UpdatePressed d4, p1
	Input_UpdatePressed d6, p2

	rts
