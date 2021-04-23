obj_max: equ $40

Obj struct dots
Type: 	 ds.b 1
    align 2

; The assembler strongly dislikes one-character element names;
; while they end up in the symbol table, it appears they're unusable :(
Pos:
Pos_X:   ds.l 1
Pos_Y:   ds.l 1

Vel:
Vel_X:	 ds.l 1
Vel_Y:	 ds.l 1

Spawn:
Spawn_X: ds.l 1
Spawn_Y: ds.l 1
Obj	endstruct

obj_types:
    phase $1
obj_type_ball:   ds.b 1
obj_type_p1:     ds.b 1
obj_type_p2:     ds.b 1
    dephase
    !org obj_types
