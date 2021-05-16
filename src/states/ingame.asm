ingame_states:
; Ingame states
	phase $0
ingame_paused: ds.b 1
	dephase

; Over states
; We can only have one at a time, so 1-255
	phase $1
ingame_over_scored: ds.b 1
	dephase
	!org ingame_states

Ingame_Init:
	; Clears both ingame_state and ingame_state_over
	clr.w ingame_state

	jsr Entity_ClearAll

	jsr Ball_Add
	Player_Add p1
	Player_Add p2

Ingame_Update:
	cmp.b #ingame_over_scored, ingame_state_over
	beq.s Ingame_Init

	btst.b #7, (input_p1_press)
	beq.s  .NoPauseToggle
	bchg.b #ingame_paused, ingame_state

.NoPauseToggle:
	btst.b #ingame_paused, ingame_state
	bne.s  .Paused

	bsr.w Entity_Update
.Paused:
	jsr   Game_NextFrame

	bra.s Ingame_Update
