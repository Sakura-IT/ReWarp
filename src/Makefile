HOST	= aos4	# can be overriden when calling make

AS	= vasmppc_std
ASOPTS	= -quiet -Felf -many -mppc32 -m403
LD	= vlink
LDOPTS	= -belf32amigaos -T$(VLIBOS4_DIR)script -P_start -P__amigaos4__ -q -s -n
LHA	= lha

DISTRIBUTION = ReWarp.lha
OBJS	= powerlib.o
POWERPC_LIB = powerpc.library

$(POWERPC_LIB): $(OBJS) 
	$(LD) $(LDOPTS) -o $@ $<
#	strip $@	# no need to call strip, -s to vlink strips all symbols?
	
%.o: %.s
	$(AS) $(ASOPTS) -o $@ $<

clean:
	$(RM) $(OBJS) $(POWERPC_LIB) $(DISTRIBUTION)

distribution: $(POWERPC_LIB)
	$(LHA) a $(DISTRIBUTION) $(POWERPC_LIB)

include Makefile.inc.$(HOST)

