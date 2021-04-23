vdp_screen_width:  equ 320
vdp_screen_height: equ 224

vdp_reg_mode1:    equ $8000  ; Mode register #1
vdp_reg_mode2:    equ $8100  ; Mode register #2
vdp_reg_mode3:    equ $8B00  ; Mode register #3
vdp_reg_mode4:    equ $8C00  ; Mode register #4

vdp_reg_planea:   equ $8200  ; Plane A table address
vdp_reg_planeb:   equ $8400  ; Plane B table address
vdp_reg_sprite:   equ $8500  ; Sprite table address
vdp_reg_window:   equ $8300  ; Window table address
vdp_reg_hscroll:  equ $8D00  ; HScroll table address

vdp_reg_size:     equ $9000  ; Plane A and B size
vdp_reg_winx:     equ $9100  ; Window X split position
vdp_reg_winy:     equ $9200  ; Window Y split position
vdp_reg_incr:     equ $8F00  ; Autoincrement
vdp_reg_bgcol:    equ $8700  ; Background color
vdp_reg_hrate:    equ $8A00  ; HBlank interrupt rate

vdp_reg_dmalen_l: equ $9300  ; DMA length (low)
vdp_reg_dmalen_h: equ $9400  ; DMA length (high)
vdp_reg_dmasrc_l: equ $9500  ; DMA source (low)
vdp_reg_dmasrc_m: equ $9600  ; DMA source (mid)
vdp_reg_dmasrc_h: equ $9700  ; DMA source (high)

vdp_ctrl:    	equ $C00004  ; VDP control port
vdp_data:    	equ $C00000  ; VDP data port
vdp_hv_counter: equ $C00008  ; H/V counter

vdp_vram_addr_cmd:  equ $40000000
vdp_cram_addr_cmd:  equ $C0000000
vdp_vsram_addr_cmd: equ $40000010
vdp_vram_size_b:    equ 65536
vdp_cram_size_b:   	equ 128
vdp_vsram_size_b:   equ 80

vdp_planea_addr:  equ $C000
vdp_planeb_addr:  equ $E000
vdp_sprite_addr:  equ $F000
vdp_window_addr:  equ $D000
vdp_hscroll_addr: equ $F400

vdp_plane_width:  equ $40
vdp_plane_height: equ $20
