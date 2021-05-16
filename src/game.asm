	include "player.asm"
	include "ball.asm"
	include "palettes.asm"
	include "tiles.asm"
	include "states/ingame.asm"
	
Game_Main:
	moveq #0, d0
	lea Palette, a0
	jsr VDP_LoadPalette

	moveq #0, d0
	moveq #tiles_count, d1
	lea Tiles, a0
	jsr VDP_LoadTiles

	; Clear trashed d0 and d1
	moveq #0, d0
	moveq #0, d1

	; Enable interrupts
	move.w #$2300, sr

	bra.w Ingame_Init

Game_NextFrame:
	jsr Input_Update

	jsr Spr_ClearTable
	jsr Entity_Draw
	jsr Spr_UpdateTable

	jsr VDP_WaitForVSync
	jsr DMA_Queue_Process

	rts

Game_HINT:
	rte
