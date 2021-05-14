;****************************************************************************
; Object_ClearAll
; Clears the object list.
;----------------------------------------------------------------------------
; breaks: none
;****************************************************************************
Object_ClearAll:
	moveq  #0, d0
	lea    obj_list, a0
	moveq #(obj_max * Obj.len) / size_long / 4, d1

.Loop:
	move.l d0, (a0)+
	move.l d0, (a0)+
	move.l d0, (a0)+
	move.l d0, (a0)+
	dbf    d1, .Loop
	rts

;****************************************************************************
; Object_Destroy
; Destroys the object, removing its slot from the list.
;----------------------------------------------------------------------------
; input a0.l ... Pointer to object
;----------------------------------------------------------------------------
; breaks: none
;****************************************************************************
Object_Destroy:
	clr.b Obj.Type(a0)
	rts

;****************************************************************************
; Object_Respawn
; Respawns an object, resetting its X and Y coordinates and clearing its velocity
;----------------------------------------------------------------------------
; input a0.l ... Pointer to object
;----------------------------------------------------------------------------
; breaks: none
;****************************************************************************
Object_Respawn:
	move.l  Obj.Spawn_X(a0), Obj.Pos_X(a0)
	move.l  Obj.Spawn_Y(a0), Obj.Pos_Y(a0)
	clr.l   Obj.Vel_X(a0)
	clr.l   Obj.Vel_Y(a0)
	rts

;****************************************************************************
; Object_Add
; Adds an object
;----------------------------------------------------------------------------
; input d0.w  ... X position
; input d1.w  ... Y position
; input d2.b  ... Type
;----------------------------------------------------------------------------
; output a0.l ... Pointer to object
;----------------------------------------------------------------------------
; breaks: d2
;****************************************************************************
Object_Add:
	lea obj_list, a0
.Loop:
	tst.b Obj.Type(a0)
	beq.s .Found
	lea   Obj.len(a0), a0
	bra.s .Loop
.Found:
	move.b  d2, Obj.Type(a0)
	move.w  d0, Obj.Pos_X(a0)
	move.w  d1, Obj.Pos_Y(a0)
	clr.l   Obj.Vel_X(a0)
	clr.l   Obj.Vel_Y(a0)
	move.w  d0, Obj.Spawn_X(a0)
	move.w  d1, Obj.Spawn_Y(a0)

	; Call init subroutine
	add.w  d2, d2
	add.w  d2, d2
	lea   .InitSubs(pc), a1
	move.l (a1,d2.w), a1
	jsr    (a1)

.Null:
	rts

.InitSubs:
	dc.l .Null
	dc.l Ball_Init
	dc.l .Null
	dc.l .Null

;****************************************************************************
; Object_Call
; Calls subroutines based on type
;----------------------------------------------------------------------------
; input a1.l  ... Call table
;----------------------------------------------------------------------------
; breaks: a1-a2, d5-d6
;****************************************************************************
Object_Call:
	lea   obj_list, a0
	moveq #obj_max - 1, d5
.Loop:
	moveq  #0, d6
	move.b Obj.Type(a0), d6

	; If the type is null, skip
	beq.s .Next

	; Save registers in stack, we don't know what we're calling
	move.w d5, -(sp)
	move.l a0, -(sp)

	; Each pointer is 4 bytes long, so multiply by four
	; The 68k sucks at multiplication so we just add d6 to itself twice
	; lsl.w #2, d6 is actually 2 cycles slower than this, although it's smaller
	add.w  d6, d6
	add.w  d6, d6
	move.l (a1,d6.w), a2
	jsr    (a2)

	; Restore registers
	move.l (sp)+, a0
	move.w (sp)+, d5

.Next:
	lea Obj.len(a0), a0 ; Go to next object..
	dbf d5, .Loop

	rts

Object_Update:
	lea   .UpdateSubs(pc), a1
	bsr.s Object_Call
.Null:
	rts
.UpdateSubs:
	dc.l .Null
	dc.l Ball_Update
	dc.l P1_Update
	dc.l P2_Update

Object_Draw:
	lea   .DrawSubs(pc), a1
	bsr.s Object_Call
.Null:
	rts
.DrawSubs:
	dc.l .Null
	dc.l Ball_Draw
	dc.l P1_Draw
	dc.l P2_Draw
