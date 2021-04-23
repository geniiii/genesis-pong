size_word: equ 2
size_long: equ 4

size_ram_b: equ $FFFF0000
size_ram_w:	equ size_ram_b / size_word
size_ram_l:	equ size_ram_b / size_long

ram_end:    equ ram_start + size_ram_b