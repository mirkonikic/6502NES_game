default:
	ca65 src/main.s -o obj/main.o
	ld65 -t nes -o bin/main.nes obj/main.o
	fceux bin/main.nes
