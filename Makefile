all:
	# nim c --threads:on -o:bin/radio src/radio.nim
	nimble build

install:
	nimble install

run:
	nimble run src/radio
