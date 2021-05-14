ball_spawn_x: equ (vdp_screen_width  - spr_ball_w_px) / 2
ball_spawn_y: equ (vdp_screen_height - spr_ball_h_px) / 2

;****************************************************************************
; Ball_Add
; Adds a ball to the object list
;----------------------------------------------------------------------------
; breaks: d0-d3, a0
;****************************************************************************
Ball_Add:
	move.w #ball_spawn_x,  d0
	move.w #ball_spawn_y,  d1
	moveq  #obj_type_ball, d2
	jsr Object_Add
	rts

Ball_Init:
	move.l #-$00022000, Obj.Vel_X(a0)
	rts

; TODO: We need to keep track of time somewhere to allow for a short pause inbetween scores
; TODO: Ball doesn't collide with paddles
Ball_Update:
	; Add velocity to positions
	; Stupid add instruction doesn't allow (aN), (aN) so we have to move these to data registers, but it saves some cycles anyways
	movem.l Obj.Pos(a0), d0-d1

	add.l  Obj.Vel_X(a0), d0
	add.l  Obj.Vel_Y(a0), d1

	swap d0
	swap d1

; Check bottom
.CheckBottom
	; If we hit the top or bottom of the screen, reverse Y velocity
	cmp.w #vdp_screen_height, d1
	bne.s .CheckTop
	neg.l Obj.Vel_Y(a0)
	; We know it can't be at the top if it's at the bottom, so skip the next check
	bra.s .CheckRight

; Check top
.CheckTop:
	tst.w d1
	bne.s .CheckRight
	neg.l Obj.Vel_Y(a0)

; If we hit the leftmost or rightmost of the screen, add score and reset game state
; Check right
.CheckRight:
	cmp.w #vdp_screen_width, d0
	blt.s .CheckLeft
	; Player 1 scored, reset ball and paddles
	add.b  #1, p1_score
	move.b #ingame_over_scored, ingame_state_over
	bra.s .End 

; Check left
.CheckLeft:
	tst.w d0
	bgt.s .WritePos
	; Player 2 scored, reset ball and paddles
	add.b #1, p2_score
	move.b #ingame_over_scored, ingame_state_over
	bra.s .End 

.WritePos:
	swap d0
	swap d1
	movem.l d0-d1, Obj.Pos(a0)
.End:
	rts

Ball_Draw:
	move.w  Obj.Pos_X(a0), d0
	move.w  Obj.Pos_Y(a0), d1
	moveq   #tile_ball_id, d2

	; Flip sprite based on direction
	tst.w Obj.Vel_X(a0)
	ble.s .NoFlip
	or.w  #spr_hflip, d2
.NoFlip:
	moveq #spr_ball_size, d3
	jsr	  Spr_Add

	rts
