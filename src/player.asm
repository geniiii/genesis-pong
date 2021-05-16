p1_x: equ 0
p2_x: equ vdp_screen_width - spr_paddle_w_px

player_speed: equ 3

Player_Add macro p
	move.w #p_x, d0
	moveq  #(vdp_screen_height - spr_paddle_h_px) / 2, d1
	moveq  #entity_type_p, d2
	jsr Entity_Add
	move.l a0, p
	endm

;****************************************************************************
; Player_AddSprite
; Adds a player's sprite to the sprite table
;----------------------------------------------------------------------------
; input flags ... Flags
;----------------------------------------------------------------------------
; breaks: d0-d5
;****************************************************************************
Player_AddSprite macro flags=0
	move.w  Entity.Pos_X(a0), d0
	move.w  Entity.Pos_Y(a0), d1
	move.w  #tile_paddle_id | flags, d2
	moveq   #spr_paddle_size, d3
	jsr	    Spr_Add
	endm

P1_Draw:
	Player_AddSprite spr_hflip
	rts
P2_Draw:
	Player_AddSprite
	rts

;****************************************************************************
; Player_Update
; Updates a player's position
;----------------------------------------------------------------------------
; input d0.b ... Buttons held
;----------------------------------------------------------------------------
; breaks: d1, d2
;****************************************************************************
Player_Update:
	; If up button held, go up
	btst.l #0, d0
	beq.s .CheckDown

	subq.w #player_speed, Entity.Pos_Y(a0)

	; Don't move up if at the top of the screen
	tst.w Entity.Pos_Y(a0)
	bge.s .CheckDown

	move.w #0, Entity.Pos_Y(a0)

.CheckDown:
	; If down button held, go down
	btst.l #1, d0
	beq.s .End

	addq.w #player_speed, Entity.Pos_Y(a0)

	; Don't move down if at the bottom of the screen
	cmp.w  #vdp_screen_height - spr_paddle_h_px, Entity.Pos_Y(a0)
	ble.s .End
	move.w #vdp_screen_height - spr_paddle_h_px, Entity.Pos_Y(a0)

.End:
	rts

P1_Update:
	move.b (input_p1_held), d0
	bsr.s Player_Update
	rts
P2_Update:
	move.b (input_p2_held), d0
	bsr.s Player_Update
	rts
