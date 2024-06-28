CC=ca65
LD=ld65
CFLAGS=-t nes -g
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
