# Build for Cirrus Logic CS8900A based devices:
# make

# Build for Standard Microsystems LAN91C96 based devices:
# make eth=sm

# Build for WIZnet W5100 based devices:
# make eth=wn

ifeq ($(eth),sm)
  C64DRIVERLIB = ../drivers/c64eth64.lib
  A2DRIVERLIB  = ../drivers/a2lancegs.lib
else ifeq ($(eth),wn)
  A2DRIVERLIB  = ../drivers/a2uther2.lib
else
  C64DRIVERLIB = ../drivers/c64rrnet.lib
  A2DRIVERLIB  = ../drivers/a2uther.lib
  VICDRIVERLIB = ../drivers/vic20rrnet.lib
endif

UDP =\
	dns \
	dottedquad \
	parsequerystring \
	sntp \
	tftp

TCP =\
	cifs \
	geturl \
	httpd \
	parser \
	ping \
	tcp

all:    $(UDP) $(TCP)
.PHONY: $(UDP) $(TCP)

$(addsuffix .prg,$(UDP)): IP65LIB = ../ip65/ip65.lib
$(addsuffix .prg,$(TCP)): IP65LIB = ../ip65/ip65_tcp.lib

$(addsuffix .bin,$(UDP)): IP65LIB = ../ip65/ip65.lib
$(addsuffix .bin,$(TCP)): IP65LIB = ../ip65/ip65_tcp.lib

$(addsuffix .vicprg,$(UDP)): IP65LIB = ../ip65/ip65.lib
$(addsuffix .vicprg,$(TCP)): IP65LIB = ../ip65/ip65_tcp.lib

$(foreach pgm,$(UDP) $(TCP),$(eval $(pgm): $(pgm).prg $(pgm).bin $(pgm).vicprg))

INCFILES =\
  ../inc/common.i \
  ../inc/commonprint.i \
  ../inc/net.i

prg: $(addsuffix .prg,$(UDP) $(TCP))

bin: $(addsuffix .bin,$(UDP) $(TCP))

vicprg: $(addsuffix .vicprg,$(UDP) $(TCP))

d64: ip65.d64

dsk: ip65.dsk

ip65:
	make -C ../ip65

drivers:
	make -C ../drivers

%.o: %.s
	ca65 $<

%.prg: %.o ip65 drivers $(INCFILES)
	ld65 -o $*.prg -C c64.cfg -m $*.c64.map -vm $< $(IP65LIB) $(C64DRIVERLIB) c64.lib

%.bin: %.o ip65 drivers $(INCFILES)
	ld65 -o $*.bin -C apple2.cfg -m $*.a2.map -vm $< $(IP65LIB) $(A2DRIVERLIB) apple2.lib

%.vicprg: %.o ip65 drivers $(INCFILES)
	ld65 -o $*.vicprg -C vic20-32k.cfg -m $*.vic.map -vm $< $(IP65LIB) $(VICDRIVERLIB) vic20.lib

ip65.d64: prg
	$(C1541) -format ip65,00 d64 $@
	$(C1541) -attach $@ -write dns.prg        dns,p
	$(C1541) -attach $@ -write dottedquad.prg dottedquad,p
	$(C1541) -attach $@ -write geturl.prg     geturl,p
	$(C1541) -attach $@ -write httpd.prg      httpd,p
	$(C1541) -attach $@ -write parser.prg     parser,p
	$(C1541) -attach $@ -write ping.prg       ping,p
	$(C1541) -attach $@ -write sntp.prg       sntp,p
	$(C1541) -attach $@ -write tcp.prg        tcp,p
	$(C1541) -attach $@ -write tftp.prg       tftp,p

ip65.dsk: bin
	cp prodos.dsk $@
	java -jar $(AC) -cc65 $@ dns        bin 0 < dns.bin
	java -jar $(AC) -cc65 $@ dottedquad bin 0 < dottedquad.bin
	java -jar $(AC) -cc65 $@ geturl     bin 0 < geturl.bin
	java -jar $(AC) -cc65 $@ httpd      bin 0 < httpd.bin
	java -jar $(AC) -cc65 $@ parser     bin 0 < parser.bin
	java -jar $(AC) -cc65 $@ ping       bin 0 < ping.bin
	java -jar $(AC) -cc65 $@ sntp       bin 0 < sntp.bin
	java -jar $(AC) -cc65 $@ tcp        bin 0 < tcp.bin
	java -jar $(AC) -cc65 $@ tftp       bin 0 < tftp.bin

clean:
	make -C ../ip65 clean
	make -C ../drivers clean
	-rm -f *.prg *.bin *.vicprg *.map
	-rm -f ip65.d64 ip65.dsk