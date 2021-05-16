memmap_start:
    phase $FFFF0000
ram_start: equ *

input_p1_press: ds.b 1
input_p1_held:  ds.b 1
input_p2_press: ds.b 1
input_p2_held:  ds.b 1

spr_num:     ds.w 1
spr_table:   ds.w spr_table_size_w

entity_list: Entity [entity_max]
; Pointers to player objects
p1:          ds.l 1
p2:          ds.l 1
p1_score:    ds.b 1
p2_score:    ds.b 1

ingame_state:      ds.b 1
ingame_state_over: ds.b 1

vdp_vblank: ds.b 1
    dephase

    ; Putting DMA stuff here to allow for (xxxx).w addressing mode
    phase $FFFF9000
vdp_command_buffer:      ds.w 7 * $12 ; Just pretend the $12 is DMAEntry.len
vdp_command_buffer_slot: ds.w 1
    dephase
    !org memmap_start
