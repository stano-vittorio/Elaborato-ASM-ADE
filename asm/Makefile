GCC = gcc
FLAGS = -m32 -c

all: bin/telemetry
	@echo Done!

bin/telemetry: obj/verifica_riga.o obj/controllo_piloti.o obj/telemetry.o obj/main.o
	@echo Linking...
	$(GCC) -m32 obj/telemetry.o obj/main.o obj/controllo_piloti.o obj/verifica_riga.o -o bin/telemetry

obj/verifica_riga.o: src/verifica_riga.s
	@echo Assembling verifica_riga...
	$(GCC) $(FLAGS) src/verifica_riga.s -o obj/verifica_riga.o

obj/controllo_piloti.o: src/controllo_piloti.s
	@echo Assembling controllo_piloti...
	$(GCC) $(FLAGS) src/controllo_piloti.s -o obj/controllo_piloti.o

obj/telemetry.o: src/telemetry.s
	@echo Assembling telemetry...
	$(GCC) $(FLAGS) src/telemetry.s -o obj/telemetry.o

obj/main.o: src/main.c
	@echo Assembling main...
	$(GCC) $(FLAGS) src/main.c -o obj/main.o

.PHONY: clean

clean:
	@echo Cleaning obj/ ...
	@echo Cleaning bin/telemetry ...
	@rm -rf obj/*
	@rm -rf bin/telemetry
	@echo Done!
