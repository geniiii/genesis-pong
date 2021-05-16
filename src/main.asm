	cpu     68000
	supmode on
	padding on
	listing purecode
	page 	0

	include "ram.asm"
	include "header.asm"
	include "input.asm"
	include "entity.asm"
	include "sprite/constants.asm"
	include "memmap.asm"
	include "dma.asm"
	include "vdp.asm"
	include "sprite/routines.asm"
	include "game.asm"

CPU_EntryPoint:
	; Initialization

	; Skip init if console was reset
	tst.w $A10008 ; Test controller 1 reset
	bne   Game_Main
	tst.w $A1000C ; Test expansion port reset
	bne   Game_Main

	; Begin setup
	; Clear RAM
    moveq   #0, d0
    move.w  #0, a0
    moveq   #(64 * size_long) / 4, d1

.Loop:
    move.l d0, -(a0)
	move.l d0, -(a0)
	move.l d0, -(a0)
    move.l d0, -(a0)
    dbf    d1, .Loop

	move.b $A10001, d0 ; Move Mega Drive hardware version to d0
	and.b  #$F, d0     ; Version is stored in last four bits
	beq.s  .SkipTMSS   ; If version = 0, skip
	move.l #'SEGA', $A14000
.SkipTMSS:

	jsr Input_Init

	lea 	ram_start, a0     ; Move address of first byte in RAM to a0
	movem.l (a0), d0-d7/a1-a7 ; Clear all registers (RAM has been cleared previously)
	move.l  #0, a0 			  ; Clear a0

	jsr	DMA_Queue_Init
	jsr VDP_Init

	; Jump to game code
	jmp Game_Main

AddressError:
	nop
	nop
	bra.s AddressError
BusError:
	nop
	nop
	bra.s BusError
IllegalInstructionError:
	nop
	nop
	bra.s IllegalInstructionError
ErrorTrap:
	nop
	nop
	bra.s ErrorTrap

ROM_End:
