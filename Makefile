CC=cc65
CA=ca65
LD=ld65
CFLAGS=-t nes -g
LFLAGS=-t nes

#assemble and link
a:
	$(CA) src/main.s -o obj/main.o $(CFLAGS)
	$(LD) obj/main.o -o bin/main.nes $(LFLAGS)

m:
	$(CA) src/main.s -o obj/main.o $(CFLAGS)
	$(LD) obj/main.o -o bin/main.nes $(LFLAGS) -m doc/map.txt

#emulate
e:	
	$(CA) src/main.s -o obj/main.o $(CFLAGS)
	$(LD) obj/main.o -o bin/main.nes $(LFLAGS)
	fceux bin/main.nes
