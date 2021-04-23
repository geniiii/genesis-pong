Spr_ClearTable:
    clr.b spr_num       ; Reset sprite count
    clr.l spr_table     ; Clear first entry
    clr.l spr_table + size_long
    rts

;****************************************************************************
; Spr_Add
; Adds an entry to the sprite table
;----------------------------------------------------------------------------
; input d0.w ... X
; input d1.w ... Y
; input d2.w ... Tile + flags
; input d3.w ... Size
;----------------------------------------------------------------------------
; breaks: d4-d5, a0
;----------------------------------------------------------------------------
; Sprite table entry:
; 2 bytes	Y coordinate
; 1 byte	Sprite size
; 1 byte	Sprite link
; 2 bytes	Tile ID and flags
; 2 bytes	X coordinate
;****************************************************************************
Spr_Add:
    cmp.w #vdp_screen_width, d0  ; Too far to the right?
    bge.s .End
    cmp.w #-32, d0               ; Too far to the left?
    ble.s .End
    cmp.w #vdp_screen_height, d1 ; Too far down?
    bge.s .End
    cmp.w #-32, d1               ; Too far up?
    ble.s .End

    lea spr_table, a0

    move.b spr_num, d4
    cmp.w  spr_num, d4  ; First sprite?
    beq.s  .First
    cmp.w  #spr_max, d4 ; Too many sprites?
    bhs.s  .End

    ; Get pointer to new entry
    moveq  #0, d5
    move.b d4, d5
    lsl.w  #3, d5
    lea    (a0,d5.w), a0

    ; Update link of previous entry
    move.b d4, -5(a0)

.First:
    ; Add offset
    moveq  #-128, d5
    sub.w  d5, d0
    sub.w  d5, d1

    ; Store entry
    move.w d1, (a0)+ ; Y
    move.b d3, (a0)+ ; Size
    move.b #0, (a0)+ ; Sprite link
    move.w d2, (a0)+ ; Tile + flags
    move.w d0, (a0)+ ; X

    ; Undo offset
    add.w d5, d0
    add.w d5, d1

    ; Update spr_num
    addq.b #1, d4
    move.b d4, spr_num

.End:
    rts

Spr_UpdateTable:    
    ; Check how many sprites there are
    moveq   #0, d0
    move.b  spr_num, d0
    beq.s   .Empty

    ; If the table has any sprites, queue DMA transfer
    move.l #spr_table, d1
    move.w #vdp_sprite_addr, d2
    move.w #spr_table_size_w, d3
    jsr DMA_Queue_Transfer
    rts
    
    ; If we get here, the table has no sprites
    ; Fill first entry with zeroes
.Empty:
    VDP_SetVRAMAddr vdp_sprite_addr
    lea vdp_data, a1

    move.l  d0, (a1)
    move.l  d0, (a1)
    rts
