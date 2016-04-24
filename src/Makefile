AS	= vasmppc_std
ASOPTS	= -quiet -Felf
LD	= vlink
LDOPTS	= -belf32amigaos -Tvlibos4:script -P_start -P__amigaos4__ -q -s -n

powerpc.library: powerlib.o
	$(LD) $(LDOPTS) -o $@ $<
	strip $@
	
powerlib.o: powerlib.s
	$(AS) $(ASOPTS) -o $@ $<
