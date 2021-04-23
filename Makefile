.PHONY: all main.p main.bin
MAKEFLAGS += --no-builtin-rules

AS = asw
ASFLAGS = -xx -q -A -U -L -M
P2BIN = p2bin

all: main.p main.bin
main.p:
	cd src && \
	$(AS) $(ASFLAGS) main.asm && \
	mv main.lst main.p main.mac ../build/
main.bin: main.p
	$(P2BIN) build/main.p build/main.bin
	romfix -z build/main.bin 	

clean:
	rm -rf build/*