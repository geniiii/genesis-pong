spr_1_1: equ %0000 ; 1x1 tiles
spr_2_1: equ %0100 ; 2x1 tiles
spr_3_1: equ %1000 ; 3x1 tiles
spr_4_1: equ %1100 ; 4x1 tiles
spr_1_2: equ %0001 ; 1x2 tiles
spr_2_2: equ %0101 ; 2x2 tiles
spr_3_2: equ %1001 ; 3x2 tiles
spr_4_2: equ %1101 ; 4x2 tiles
spr_1_3: equ %0010 ; 1x3 tiles
spr_2_3: equ %0110 ; 2x3 tiles
spr_3_3: equ %1010 ; 3x3 tiles
spr_4_3: equ %1110 ; 4x3 tiles
spr_1_4: equ %0011 ; 1x4 tiles
spr_2_4: equ %0111 ; 2x4 tiles
spr_3_4: equ %1011 ; 3x4 tiles
spr_4_4: equ %1111 ; 4x4 tiles

spr_hflip:  equ $0800 ; Flip horizontally
spr_vflip:  equ $1000 ; Flip vertically
spr_vhflip: equ $1800 ; Flip both ways

spr_max: equ 80

spr_table_size_b: equ 8 * spr_max
spr_table_size_w: equ spr_table_size_b / size_word