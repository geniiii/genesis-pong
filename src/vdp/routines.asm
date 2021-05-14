VDP_SetXRAMAddr  macro addr, cmd
    move.l  #(((addr) & $3FFF) << 16) | (((addr) & $C000) >> 14) | (cmd), vdp_ctrl
    endm
VDP_SetVRAMAddr  macro ADDR
    VDP_SetXRAMAddr ADDR, vdp_vram_addr_cmd
    endm
VDP_SetCRAMAddr  macro ADDR
    VDP_SetXRAMAddr ADDR, vdp_cram_addr_cmd
    endm
VDP_SetVSRAMAddr macro ADDR
    VDP_SetXRAMAddr ADDR, vdp_vsram_addr_cmd
    endm

VDP_SetXRAMAddrReg macro reg, cmd
    ; This is equivalent to "andi.l #$FFFF, reg", but faster
    swap reg
    clr.w reg
    swap reg

    lsl.l   #2, reg
    lsr.w   #2, reg
    swap    reg
    or.l    #cmd, reg
    move.l  reg, vdp_ctrl
    endm
VDP_SetVRAMAddrReg: macro reg
    VDP_SetXRAMAddrReg reg, vdp_vram_addr_cmd
    endm
VDP_SetCRAMAddrReg: macro reg
    VDP_SetXRAMAddrReg reg, vdp_cram_addr_cmd
    endm
VDP_SetVSRAMAddrReg: macro reg
    VDP_SetXRAMAddrReg reg, vdp_vsram_addr_cmd
    endm

VDP_Init:
	tst.w vdp_ctrl

	lea vdp_ctrl, a0

    ; See https://www.plutiedev.com/vdp-registers
	move.w #vdp_reg_mode1   | %00000110, (a0) ; Mode register #1
	move.w #vdp_reg_mode2   | %01110100, (a0) ; Mode register #2
	move.w #vdp_reg_mode3   | %00000000, (a0) ; Mode register #3
	move.w #vdp_reg_mode4   | %10000001, (a0) ; Mode register #4

	move.w #vdp_reg_planea  | (vdp_planea_addr  >> 10), (a0) ; Plane A address
	move.w #vdp_reg_planeb  | (vdp_planeb_addr  >> 13), (a0) ; Plane B address
	move.w #vdp_reg_sprite  | (vdp_sprite_addr  >> 9),  (a0) ; Sprite address
    move.w #vdp_reg_hscroll | (vdp_hscroll_addr >> 10), (a0) ; HScroll address
	move.w #vdp_reg_window  | $00, (a0) ; Window address
 
	move.w #vdp_reg_size    | $01, (a0) ; Tilemap size
	move.w #vdp_reg_winx    | $00, (a0) ; Window X split
	move.w #vdp_reg_winy    | $00, (a0) ; Window Y split
	move.w #vdp_reg_incr    | $02, (a0) ; Autoincrement
	move.w #vdp_reg_bgcol   | $00, (a0) ; Background color
	move.w #vdp_reg_hrate   | $08, (a0) ; HBlank IRQ rate

	jmp VDP_Clear

VDP_Clear:
    moveq   #0, d0         ; To write zeroes
    lea     vdp_ctrl, a0   ; VDP control port
    lea     vdp_data, a1   ; VDP data port

    ; Clear VRAM
    DMA_FillVRAM 0, 0, vdp_vram_size_b

    ; Clear CRAM
    ; DMA fill to CRAM/VSRAM is possible but apparently quite buggy, so we do this instead
    ; It should be possible to optimize these loops using movem, but I don't think the gains are all that significant
    VDP_SetCRAMAddr $0000
    moveq  #(vdp_cram_size_b / size_long) / 4 - 1, d1
.ClearCram:
    move.l  d0, (a1)
    move.l  d0, (a1)
    move.l  d0, (a1)
    move.l  d0, (a1)
    dbf     d1, .ClearCram
    
    ; Clear VSRAM
    VDP_SetVSRAMAddr $0000
    moveq  #(vdp_vsram_size_b / size_long) / 4 - 1, d1
.ClearVsram:
    move.l  d0, (a1)
    move.l  d0, (a1)
    move.l  d0, (a1)
    move.l  d0, (a1)
    dbf     d1, .ClearVsram

	rts

; d0.w = VRAM address
; d1.w = number of words (*not* bytes)
; a0.l = pointer to data
VDP_CopyToVRAM:
    VDP_SetVRAMAddrReg d0

    subq.w  #1, d1
    blo.s   .End
    lea     vdp_data, a1
.Loop:
    move.w  (a0)+, (a1)
    dbf     d1, .Loop

.End:
    rts

; d0.w = first tile number
; d1.w = number of tiles
; a0.l = pointer to tiles
VDP_LoadTiles:
    lsl.w   #5, d0
    VDP_SetVRAMAddrReg d0

    ; Copy them to VRAM
    ; 1 iteration = 1 tile
    subq.w  #1, d1
    lea     vdp_data, a1
.Loop:
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    dbf     d1, .Loop

    rts

; d0.w = palette number
; a0.l = pointer to palette
VDP_LoadPalette:
    ; Tell VDP where to write
    lsl.w #5, d0
    VDP_SetCRAMAddrReg d0
    
    ; Copy the whole palette
    lea     vdp_data, a1
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    move.l  (a0)+, (a1)
    
    rts

VDP_VInt:
    st.b vdp_vblank
    rte
VDP_HInt:
	rte

VDP_WaitForVSync:
    clr.b vdp_vblank
.Wait:
    tst.b vdp_vblank
    beq.s .Wait

    rts
