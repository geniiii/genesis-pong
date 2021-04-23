tile_size_b: equ 8

Tiles:
tile_blank:
	dc.l $00000000
	dc.l $00000000
	dc.l $00000000
	dc.l $00000000
	dc.l $00000000
	dc.l $00000000
	dc.l $00000000
	dc.l $00000000

Tile macro Name, W=1, H=1
	tile_Name: binclude "../data/sprites/Name.4bpp"
	spr_Name_w: equ W
	spr_Name_h: equ H
	spr_Name_w_px: equ W * tile_size_b
	spr_Name_h_px: equ H * tile_size_b
	spr_Name_size: equ spr_W_H
	endm

	Tile paddle, 1, 4
	Tile ball,   2, 2

Tiles_End:
tiles_count: equ (Tiles_End - Tiles) / 32

	phase $0
tile_blank_id:   ds.b 1
tile_paddle_id:  ds.b spr_paddle_w * spr_paddle_h
tile_ball_id:    ds.b spr_ball_w   * spr_ball_h
	dephase
	!org Tiles_End
