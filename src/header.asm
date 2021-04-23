ROM_Start:
	if (*) <> 0
	fatal	"Start of ROM is at address $\{*}, but it should be at address 0."
	endif

stack_initial: equ $00FFE000
Header_Start:
	dc.l stack_initial           ; Initial Stack Address
	dc.l CPU_EntryPoint        	 ; Start of program Code
	dc.l BusError             	 ; Bus error
	dc.l AddressError            ; Address error
	dc.l IllegalInstructionError ; Illegal instruction
	dc.l IllegalInstructionError ; Division by zero
	dc.l IllegalInstructionError ; CHK exception
	dc.l ErrorTrap             	 ; TRAPV exception
	dc.l ErrorTrap             	 ; Privilage violation
	dc.l ErrorTrap             	 ; TRACE exception
	dc.l ErrorTrap             	 ; Line-A emulator
	dc.l ErrorTrap             	 ; Line-F emulator
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Co-processor protocol violation
	dc.l ErrorTrap             	 ; Format error
	dc.l ErrorTrap             	 ; Uninitialized Interrupt
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Spurious Interrupt
	dc.l ErrorTrap             	 ; IRQ Level 1
	dc.l ErrorTrap             	 ; IRQ Level 2 (EXT Interrupt)
	dc.l ErrorTrap             	 ; IRQ Level 3
	dc.l VDP_HInt		      	 ; IRQ Level 4 (VDP Horizontal Interrupt)
	dc.l ErrorTrap             	 ; IRQ Level 5
	dc.l VDP_VInt	          	 ; IRQ Level 6 (VDP Vertical Interrupt)
	dc.l ErrorTrap             	 ; IRQ Level 7
	dc.l ErrorTrap             	 ; TRAP #00 Exception
	dc.l ErrorTrap             	 ; TRAP #01 Exception
	dc.l ErrorTrap             	 ; TRAP #02 Exception
	dc.l ErrorTrap             	 ; TRAP #03 Exception
	dc.l ErrorTrap             	 ; TRAP #04 Exception
	dc.l ErrorTrap             	 ; TRAP #05 Exception
	dc.l ErrorTrap             	 ; TRAP #06 Exception
	dc.l ErrorTrap             	 ; TRAP #07 Exception
	dc.l ErrorTrap             	 ; TRAP #08 Exception
	dc.l ErrorTrap             	 ; TRAP #09 Exception
	dc.l ErrorTrap             	 ; TRAP #10 Exception
	dc.l ErrorTrap             	 ; TRAP #11 Exception
	dc.l ErrorTrap             	 ; TRAP #12 Exception
	dc.l ErrorTrap             	 ; TRAP #13 Exception
	dc.l ErrorTrap             	 ; TRAP #14 Exception
	dc.l ErrorTrap             	 ; TRAP #15 Exception
	dc.l ErrorTrap             	 ; (FP) Branch or Set on Unordered Condition
	dc.l ErrorTrap             	 ; (FP) Inexact Result
	dc.l ErrorTrap             	 ; (FP) Divide by Zero
	dc.l ErrorTrap             	 ; (FP) Underflow
	dc.l ErrorTrap             	 ; (FP) Operand Error
	dc.l ErrorTrap             	 ; (FP) Overflow
	dc.l ErrorTrap             	 ; (FP) Signaling NAN
	dc.l ErrorTrap             	 ; (FP) Unimplemented Data Type
	dc.l ErrorTrap             	 ; MMU Configuration Error
	dc.l ErrorTrap             	 ; MMU Illegal Operation Error
	dc.l ErrorTrap             	 ; MMU Access Violation Error
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)
	dc.l ErrorTrap             	 ; Reserved (NOT USED)

	dc.b "SEGA MEGA DRIVE "                                 ; Console name
	dc.b "GENI            "                                 ; Copyright holder and release date
	dc.b "PONG                                            " ; Domestic name
	dc.b "PONG                                            " ; International name
	dc.b "GM XXXXXXXX-XX"                                   ; Version number
	dc.w $0000                                              ; Checksum
	dc.b "J               "                                 ; I/O support
	dc.l ROM_Start                                          ; Start address of ROM
	dc.l ROM_End-1                                          ; End address of ROM
	dc.l ram_start                                          ; Start address of RAM
	dc.l ram_end                              			    ; End address of RAM
	dc.l $00000000                                          ; SRAM enabled
	dc.l $00000000                                          ; Unused
	dc.l $00000000                                          ; Start address of SRAM
	dc.l $00000000                                          ; End address of SRAM
	dc.l $00000000                                          ; Unused
	dc.l $00000000                                          ; Unused
	dc.b "                                        "         ; Notes (unused)
	dc.b "JUE             "                                 ; Country codes

Header_End:
	if (*) <> $200
	fatal	"End of header is at address $\{*}, but it should be at address $200. The header + the vector table must be exactly 512 bytes long"
	endif
