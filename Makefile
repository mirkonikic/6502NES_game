CC=/home/mirko/Documents/Work/6502/6502_game/cc65/bin/ca65
LD=/home/mirko/Documents/Work/6502/6502_game/cc65/bin/ld65
CFLAGS=-t nes
LFLAGS=-t nes

#assemble and link
a:
	$(CC) src/main.s -o obj/main.o $(CFLAGS)
	$(LD) obj/main.o -o bin/main.nes $(LFLAGS)

m:
	$(CC) src/main.s -o obj/main.o $(CFLAGS)
	$(LD) obj/main.o -o bin/main.nes $(LFLAGS) -m doc/map.txt

#emulate
e:	
	$(CC) src/main.s -o obj/main.o $(CFLAGS)
	$(LD) obj/main.o -o bin/main.nes $(LFLAGS)
	fceux bin/main.nes
