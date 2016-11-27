#LibBase
.set LIBF_SUMUSED,2
.set LIBF_CHANGED,4
.set LIBF_DELEXP,8

.set MACHF_PPC600LIKE,0			#603/604/750/7400
.set MACHF_PPC400LIKE,1			#440/460
.set MACHF_PPC500LIKE,2			#500/5500/PA6T

.set lib_Flags,14
.set lib_Version,20
.set lib_Revision,22
.set lib_IdString,24
.set lib_OpenCnt,32

.set libwarp_SegList,36
.set libwarp_IExec,40
.set libwarp_IDOS,44
.set libwarp_ITimer,48
.set libwarp_IUtility,52
.set libwarp_CachedTask,56
.set libwarp_MachineFlag,60
.set libwarp_Private1,64
.set libwarp_Private2,68
.set libwarp_StartTimeVal,72
.set libwarp_sr0,80
.set libwarp_sr1,84
.set libwarp_sr2,88
.set libwarp_sr3,92
.set libwarp_sr4,96
.set libwarp_sr5,100
.set libwarp_sr6,104
.set libwarp_sr7,108
.set libwarp_PortSem,112
.set libwarp_SemSem,158
.set libwarp_MemSem,204
.set libwarp_CacheFlag,251
.set libwarp_MemList,252
.set libwarp_TaskList,264
.set libwarp_AlignmentExcHigh,276
.set libwarp_AlignmentExcLow,280
.set libwarp_OldAlignmentExc,284
.set libwarp_PosSize,288

.set EXCDATA_TYPE,8				#Always NT_INTERRUPT
.set EXCDATA_PRI,9				#This
.set EXCDATA_NAME,10
.set EXCDATA_CODE,14
.set EXCDATA_DATA,18
.set EXCDATA_TASK,22
.set EXCDATA_FLAGS,26
.set EXCDATA_EXCID,30
.set EXCDATA_UNKNOWN1,34
.set EXCDATA_UNKNOWN2,38
.set EXCDATA_UNKNOWN3,42			#Up and including this copied to MEM
.set EXCDATA_LASTEXC,46
.set EXCDATA_MCHECK,50
.set EXCDATA_DACCESS,54
.set EXCDATA_IACCESS,58
.set EXCDATA_ALIGN,62
.set EXCDATA_PROGRAM,66
.set EXCDATA_FPUN,70
.set EXCDATA_DECREMENTER,74
.set EXCDATA_SYSTEMCALL,78
.set EXCDATA_TRACE,82
.set EXCDATA_PERFMON,86
.set EXCDATA_IABR,90
.set EXCDATA_INTERRUPT,94
.set EXCRETURN_ABORT,1
.set XCO_SIZE,8
.set EC_SIZE,424

.set TASKPPC_BAT0,0
.set TASKPPC_BAT1,16
.set TASKPPC_BAT2,32
.set TASKPPC_BAT3,48

.set CHMMU_BAT0,0
.set CHMMU_BAT1,1
.set CHMMU_BAT2,2
.set CHMMU_BAT3,3

.set CHMMU_STANDARD,1
.set CHMMU_BAT,2

.set CONTEXT_CODE,		0
.set CONTEXT_SRR1,		4
.set CONTEXT_LR,		8
.set CONTEXT_CR,		12
.set CONTEXT_CTR,		16
.set CONTEXT_XER,		20
.set CONTEXT_REGS,		24		#128 bytes long
.set CONTEXT_STACK,		28		#r1
.set CONTEXT_TOC,		32		#r2
.set CONTEXT_R3,		36
.set CONTEXT_R4,		40
.set CONTEXT_R5,		44
.set CONTEXT_R6,		48
.set CONTEXT_R7,		52
.set CONTEXT_R8,		56
.set CONTEXT_R9,		60
.set CONTEXT_R10,		64
.set CONTEXT_FREGS,		152		#256 bytes long
.set CONTEXT_BATS,		412		#64 bytes long
.set CONTEXT_SEGMENTS,		480		#64 bytes long		
.set CONTEXT_LENGTH,		544		#End of context

.set MACHINESTATE_DEFAULT,	PSL_IR|PSL_DR|PSL_FP|PSL_PR|PSL_EE
.set SysStack,			0x10000			#Length max $8000

.set MEMF_PUBLIC,		0x00000001
.set MEMF_CHIP,			0x00000002
.set MEMF_FAST,			0x00000004
.set MEMF_CLEAR,		0x00010000
.set MEMF_SHARED,		0x00001000
.set MEMF_PPC,			0x00002000
.set MEMF_REVERSE,		0x00040000

.set MEMB_CHIP,			0x1

.set EXCATTR_CODE,		0x80101000		#
.set EXCATTR_DATA,		0x80101001		#
.set EXCATTR_TASK,		0x80101002		#
.set EXCATTR_EXCID,		0x80101003		#
.set EXCATTR_FLAGS,		0x80101004		#
.set EXCATTR_NAME,		0x80101005		#
.set EXCATTR_PRI,		0x80101006		#

.set PPCINFO_CPU,		0x80102000		#CPU type (see below)
.set PPCINFO_PVR,             	0x80102001		#PVR value
.set PPCINFO_ICACHE,          	0x80102002		#Instruction cache state
.set PPCINFO_DCACHE,          	0x80102003		#Data cache state
.set PPCINFO_PAGETABLE,       	0x80102004		#Page table location
.set PPCINFO_TABLESIZE,       	0x80102005		#Page table size
.set PPCINFO_BUSCLOCK,        	0x80102006		#PPC bus clock
.set PPCINFO_CPUCLOCK,        	0x80102007		#PPC CPU clock
.set PPCINFO_CPULOAD,         	0x80102008		#Total CPU usage *100 [%]
.set PPCINFO_SYSTEMLOAD,      	0x80102009		#Total system load *100 [%]
.set PPCINFO_L2CACHE,		0x8010200A		#State of L2 Cache (on/off)
.set PPCINFO_L2STATE,		0x8010200B		#L2 in copyback or writethrough?
.set PPCINFO_L2SIZE,		0x8010200C		#Size of L2 Cache

.set HINFO_ALEXC_HIGH,		0x80103000		#For GetHALInfo
.set HINFO_ALEXC_LOW,		0x80103001
.set HINFO_DSEXC_HIGH,		0x80103002
.set HINFO_DSEXC_LOW,		0x80103003

.set SCHED_REACTION,		0x80104000		#Reaction time of low-activity tasks
			
.set CPUF_G3,			0x00200000
.set CPUF_G4,			0x00400000
.set CPUF_750,			0x00200000
.set CPUF_7400,			0x00400000

.set CPUF_603E,			0x00000100
.set CPUF_604E,			0x00010000

.set CPUTYPE_PPC603E,		1
.set CPUTYPE_PPC604E,		2

.set EXC_GLOBAL,0            				#global handler
.set EXC_LOCAL,1             				#task dependant handler
.set EXC_SMALLCONTEXT,2      				#small context structure
.set EXC_LARGECONTEXT,3      				#large context structure
.set EXC_ACTIVE,4            				#private

.set EXCF_GLOBAL,		0x00000001
.set EXCF_LOCAL,		0x00000002
.set EXCF_SMALLCONTEXT,		0x00000004
.set EXCF_LARGECONTEXT,		0x00000008
.set EXCF_ACTIVE,		0x00000010

.set EXCF_MCHECK,		0x00000004
.set EXCF_DACCESS,		0x00000008
.set EXCF_IACCESS,		0x00000010
.set EXCF_INTERRUPT,		0x00000020
.set EXCF_ALIGN,		0x00000040
.set EXCF_PROGRAM,		0x00000080
.set EXCF_FPUN,			0x00000100
.set EXCF_DECREMENTER,		0x00000200
.set EXCF_SYSTEMCALL,		0x00001000
.set EXCF_TRACE,		0x00002000
.set EXCF_PERFMON,		0x00008000
.set EXCF_IABR,			0x00080000

.set EXC_MCHECK,2            				#machine check exception
.set EXC_DACCESS,3           				#data access exception
.set EXC_IACCESS,4           				#instruction access exception
.set EXC_INTERRUPT,5         				#external interrupt (V15+)
.set EXC_ALIGN,6             				#alignment exception
.set EXC_PROGRAM,7           				#program exception
.set EXC_FPUN,8              				#FP unavailable exception
.set EXC_DECREMENTER,9					#Decrementer exception
.set EXC_SYSTEMCALL,12					#sc instruction exception
.set EXC_TRACE,13            				#trace exception
.set EXC_PERFMON,15          				#performance monitor exception
.set EXC_IABR,19 					#IA breakpoint exception

.set FPF_EN_OVERFLOW,0        				#enable overflow exception
.set FPF_EN_UNDERFLOW,1       				#enable underflow exception
.set FPF_EN_ZERODIVIDE,2      				#enable zerodivide exception
.set FPF_EN_INEXACT,3         				#enable inexact op. exception
.set FPF_EN_INVALID,4         				#enable invalid op. exception
.set FPF_DIS_OVERFLOW,5       				#disable overflow exception
.set FPF_DIS_UNDERFLOW,6      				#disable underflow exception
.set FPF_DIS_ZERODIVIDE,7     				#disable zerodivide exception
.set FPF_DIS_INEXACT,8        				#disable inexact op. exception
.set FPF_DIS_INVALID,9        				#disable invalid op. exception

.set FPF_ENABLEALL,		0x0000001f		#enable all FP exceptions
.set FPF_DISABLEALL,		0x000003e0		#disable all FP exceptions

.set SDR1,25
.set PID0,48
.set MAS0,624
.set MAS1,625
.set MAS2,626
.set MAS3,627
.set MAS4,628
.set MAS6,630
.set PID1,633
.set PID2,634
.set IABR,1010
.set DABR,1013

.set HID0,1008
.set HID0_NHR,			0x00010000
.set HID0_ICFI,			0x00000800
.set HID0_DCFI,			0x00000400
.set HID0_ICE,			0x00008000
.set HID0_DCE,			0x00004000
.set HID0_ILOCK,		0x00002000
.set HID0_DLOCK,		0x00001000
.set HID0_SGE,			0x00000080
.set HID0_BTIC,			0x00000020
.set HID0_BHTE,			0x00000004
.set HID1,1009

.set PICR1,0xA8			#Processor Interface Configuration Register 1
.set PICR1_CF_MP_MULTI,		0x00000003
.set PICR1_SPEC_PCI,		0x00000004
.set PICR1_CF_APARK,		0x00000008
.set PICR1_CF_LOOP_SNOOP,	0x00000010
.set PICR1_CF_LE_MODE,		0x00000020
.set PICR1_ST_GATH_EN,		0x00000040
.set PICR1_NO_BUS_WIDTH_CHECK,	0x00000080
.set PICR1_TEA_EN,		0x00000400
.set PICR1_MCP_EN,		0x00000800
.set PICR1_FLASH_WR_EN,		0x00001000
.set PICR1_CF_LBA_EN,		0x00002000
.set PICR1_PROC_TYPE_7XX,	0x00040000
.set VAL_PICR1,			PICR1_SPEC_PCI|PICR1_CF_APARK|PICR1_CF_LOOP_SNOOP|PICR1_ST_GATH_EN|PICR1_TEA_EN|PICR1_MCP_EN|PICR1_FLASH_WR_EN|PICR1_PROC_TYPE_7XX

.set PICR2,0xAC			#Processor Interface Configuration Register 2
.set PICR2_CF_LBCLAIM_WS,	0x00000600
.set VAL_PICR2,			PICR2_CF_LBCLAIM_WS

.set PMCR1,0x70			#Peripheral Logic Power Management Configuration Register 1
.set PMCR1_SLEEP,		0x0008
.set PMCR1_NAP,			0x0010
.set PMCR1_DOZE,		0x0020
.set PMCR1_BR1_WAKE,		0x0040
.set PMCR1_PM,			0x0080
.set PMCR1_LP_REF_EN,		0x1000
.set PMCR1_NO_SLEEP_MSG,	0x4000
.set PMCR1_NO_NAP_MSG,		0x8000
.set PMCR1_NO_MSG,		0xC000
.set VAL_PMCR1,			PMCR1_DOZE|PMCR1_BR1_WAKE|PMCR1_LP_REF_EN|PMCR1_NO_MSG

.set CACHE_DCACHEOFF,1
.set CACHE_DCACHEON,2
.set CACHE_DCACHELOCK,3
.set CACHE_DCACHEUNLOCK,4
.set CACHE_DCACHEFLUSH,5
.set CACHE_ICACHEOFF,6
.set CACHE_ICACHEON,7
.set CACHE_ICACHELOCK,8
.set CACHE_ICACHEUNLOCK,9
.set CACHE_ICACHEINV,10
.set CACHE_DCACHEINV,11
.set CACHE_L2CACHEON,12
.set CACHE_L2CACHEOFF,13
.set CACHE_L2WTON,14
.set CACHE_L2WTOFF,15

.set CACRF_ClearI,8

.set SRR1_TRAP,14

.set srr1,27
.set srr0,26
.set ibat0u,528
.set ibat0l,529
.set ibat1u,530
.set ibat1l,531
.set ibat2u,532
.set ibat2l,533
.set ibat3u,534
.set ibat3l,535
.set dbat0u,536
.set dbat0l,537
.set dbat1u,538
.set dbat1l,539
.set dbat2u,540
.set dbat2l,541
.set dbat3u,542
.set dbat3l,543
.set l2cr,1017

.set HW_TRACEON,1				#enable singlestep mode
.set HW_TRACEOFF,2				#disable singlestep mode
.set HW_BRANCHTRACEON,3				#enable branch trace mode
.set HW_BRANCHTRACEOFF,4			#disable branch trace mode
.set HW_FPEXCON,5				#enable FP exceptions
.set HW_FPEXCOFF,6				#disable FP exceptions
.set HW_SETIBREAK,7				#set instruction breakpoint
.set HW_CLEARIBREAK,8				#clear instruction breakpoint
.set HW_SETDBREAK,9				#set data breakpoint (604[E] only)
.set HW_CLEARDBREAK,10
.set HW_NOTAVAILABLE,0
.set HW_AVAILABLE,-1

.set POOL_PUDDLELIST,0
.set POOL_BLOCKLIST,12
.set POOL_REQUIREMENTS,24
.set POOL_PUDDLESIZE,28
.set POOL_TRESHSIZE,32
.set POOL_SIZE,44				#Room for MLN

.set SPRG0,272
.set SPRG1,273
.set SPRG2,274
.set SPRG3,275

.set	PSL_VEC,	0x02000000	#/* ..6. AltiVec vector unit available */
.set	PSL_SPV,	0x02000000	#/* B... (e500) SPE enable */
.set	PSL_UCLE,	0x00400000	#/* B... user-mode cache lock enable */
.set	PSL_POW,	0x00040000	#/* ..6. power management */
.set	PSL_WE,		PSL_POW		#/* B4.. wait state enable */
.set	PSL_TGPR,	0x00020000	#/* ..6. temp. gpr remapping (mpc603e) */
.set	PSL_CE,		PSL_TGPR	#/* B4.. critical interrupt enable */
.set	PSL_ILE,	0x00010000	#/* ..6. interrupt endian mode (1 == le) */
.set	PSL_EE,		0x00008000	#/* B468 external interrupt enable */
.set	PSL_PR,		0x00004000	#/* B468 privilege mode (1 == user) */
.set	PSL_FP,		0x00002000	#/* B.6. floating point enable */
.set	PSL_ME,		0x00001000	#/* B468 machine check enable */
.set	PSL_FE0,	0x00000800	#/* B.6. floating point mode 0 */
.set	PSL_SE,		0x00000400	#/* ..6. single-step trace enable */
.set	PSL_DWE,	PSL_SE		#/* .4.. debug wait enable */
.set	PSL_UBLE,	PSL_SE		#/* B... user BTB lock enable */
.set	PSL_BE,		0x00000200	#/* ..6. branch trace enable */
.set	PSL_DE,		PSL_BE		#/* B4.. debug interrupt enable */
.set	PSL_FE1,	0x00000100	#/* B.6. floating point mode 1 */
.set	PSL_IP,		0x00000040	#/* ..6. interrupt prefix */
.set	PSL_IR,		0x00000020	#/* .468 instruction address relocation */
.set	PSL_IS,		PSL_IR		#/* B... instruction address space */
.set	PSL_DR,		0x00000010	#/* .468 data address relocation */
.set	PSL_DS,		PSL_DR		#/* B... data address space */
.set	PSL_PM,		0x00000008	#/* ..6. Performance monitor */
.set	PSL_PMM,	PSL_PM		#/* B... Performance monitor */
.set	PSL_RI,		0x00000002	#/* ..6. recoverable interrupt */
.set	PSL_LE,		0x00000001	#/* ..6. endian mode (1 == le) */

# general BAT defines for bit settings to compose BAT regs
# represent all the different block lengths
# The BL field	 is part of the Upper Bat Register

.set BAT_BL_128K,		0x00000000
.set BAT_BL_256K,		0x00000004
.set BAT_BL_512K,		0x0000000C
.set BAT_BL_1M,			0x0000001C
.set BAT_BL_2M,			0x0000003C
.set BAT_BL_4M,			0x0000007C
.set BAT_BL_8M,			0x000000FC
.set BAT_BL_16M,		0x000001FC
.set BAT_BL_32M,		0x000003FC
.set BAT_BL_64M,		0x000007FC
.set BAT_BL_128M,		0x00000FFC
.set BAT_BL_256M,		0x00001FFC

# supervisor/user valid mode definitions  - Upper BAT
.set BAT_VALID_SUPERVISOR,	0x00000002
.set BAT_VALID_USER,		0x00000001
.set BAT_INVALID,		0x00000000

# WIMG bit settings  - Lower BAT
.set BAT_WRITE_THROUGH,		0x00000040
.set BAT_CACHE_INHIBITED,	0x00000020
.set BAT_COHERENT,		0x00000010
.set BAT_GUARDED,		0x00000008

# WIMG bit settings  - Lower PTE
.set PTE_WRITE_THROUGH,		0x00000008
.set PTE_CACHE_INHIBITED,	0x00000004
.set PTE_COHERENT,		0x00000002
.set PTE_GUARDED,		0x00000001

# Settings for segment registers
.set SR_NO_EXECUTE,		0x10000000

# Protection bits - Lower BAT
.set BAT_NO_ACCESS,		0x00000000
.set BAT_READ_ONLY,		0x00000001
.set BAT_READ_WRITE,		0x00000002

# Tags for CreateTaskPPC
.set TASKATTR_CODE,		0x80100000
.set TASKATTR_EXITCODE,		0x80100001
.set TASKATTR_NAME,		0x80100002
.set TASKATTR_PRI,		0x80100003
.set TASKATTR_STACKSIZE,	0x80100004
.set TASKATTR_R2,		0x80100005
.set TASKATTR_R3,		0x80100006
.set TASKATTR_R4,		0x80100007
.set TASKATTR_R5,		0x80100008
.set TASKATTR_R6,		0x80100009
.set TASKATTR_R7,		0x8010000A
.set TASKATTR_R8,		0x8010000B
.set TASKATTR_R9,		0x8010000C
.set TASKATTR_R10,		0x8010000D
.set TASKATTR_SYSTEM,		0x8010000E
.set TASKATTR_MOTHERPRI,	0x8010000F
.set TASKATTR_BAT,		0x80100010
.set TASKATTR_PRIVATE,		0x80100011
.set TASKATTR_NICE,		0x80100012
.set TASKATTR_INHERITR2,	0x80100013
.set TASKATTR_ATOMIC,		0x80100014
.set TASKATTR_NOTIFYMSG,	0x80100015

.set NP_ENTRY,			0x800003eb
.set NP_NAME,			0x800003f4
.set NP_STACKSIZE,		0x800003f3
.set NP_PRIORITY,		0x800003f5
.set NP_USERDATA,		0x80000402
.set NP_CHILD,			0x80000403
.set NP_ENTRYDATA,		0x80000409

# Bit defines for the L2CR register
.set L2CR_L2E,			0x80000000 		# bit 0 - enable
.set L2CR_L2PE,			0x40000000 		# bit 1 - data parity
.set L2CR_L2SIZ_2M,		0x00000000	 	# bits 2-3 2 MB; MPC7400 ONLY!
.set L2CR_L2SIZ_1M,		0x30000000 		# bits 2-3 1MB
.set L2CR_L2SIZ_HM,		0x20000000 		# bits 2-3 512K
.set L2CR_L2SIZ_QM,		0x10000000 		# bits 2-3 256K; MPC750 ONLY
.set L2CR_L2CLK_1,		0x02000000 		# bits 4-6 Clock Ratio div 1
.set L2CR_L2CLK_1_5,		0x04000000 		# bits 4-6 Clock Ratio div 1.5
.set L2CR_L2CLK_2,		0x08000000 		# bits 4-6 Clock Ratio div 2
.set L2CR_L2CLK_2_5,		0x0a000000 		# bits 4-6 Clock Ratio div 2.5
.set L2CR_L2CLK_3,		0x0c000000 		# bits 4-6 Clock Ratio div 3
.set L2CR_L2RAM_BURST,		0x01000000 		# bits 7-8 burst SRAM
.set L2CR_DO,			0x00400000 		# bit 9 Disable caching of instr. in L2
.set L2CR_L2I,			0x00200000 		# bit 10 Global invalidate bit
.set L2CR_TS,			0x00040000 		# bit 13 Test support on 
.set L2CR_L2WT,			0x00080000		# bit 12 write-through
.set L2CR_L2OH_5,		0x00000000 		# bits 14-15 Output Hold time = 0.5ns*/
.set L2CR_L2OH_1,		0x00010000 		# bits 14-15 Output Hold time = 1.0ns*/
.set L2CR_L2OH_INV,		0x00020000 		# bits 14-15 Output Hold time = 1.0ns*/
.set L2CR_L2IP,			0x00000001

.set L2CR_SIZE_1MB,		0x3000
.set L2CR_SIZE_512KB,		0x2000
.set L2CR_SIZE_256KB,		0x1000
.set L2CR_TS_OFF,		0x0004

.set L2_ADR_INCR,		0x100
.set L2_SIZE_1M,		0x1000
.set L2_SIZE_HM,		0x800
.set L2_SIZE_QM,		0x400

.set L2_SIZE_1M_U,		0x0010
.set L1_CACHE_LINE_SIZE,32

# Node defines
.set NT_TASK,1
.set NT_INTERRUPT,2
.set NT_MESSAGE,5
.set NT_FREEMSG,6
.set NT_REPLYMSG,7
.set NT_LIBRARY,9
.set NT_MEMORY,10
.set NT_PROCESS,13
.set NT_EXTINTERRUPT,20
.set NT_PPCTASK,100
.set NT_MSGPORTPPC,101
.set NT_XMSG68K,102
.set NT_XMSGPPC,103

.set LN_SUCC,0
.set LN_PRED,4
.set LN_TYPE,8
.set LN_PRI,9
.set LN_NAME,10
.set LN_SIZE,14

#Task defines
.set TC_FLAGS,14
.set TC_STATE,15
.set TC_SIGALLOC,18
.set TC_SIGWAIT,22
.set TC_SIGRECVD,26
.set TC_SIGEXCEPT,30
.set TC_EXCEPTDATA,38
.set TC_EXCEPTCODE,42
.set TC_TRAPDATA,46
.set TC_TRAPCODE,50
.set TC_SPREG,54
.set TC_SPLOWER,58
.set TC_SPUPPER,62
.set TC_MEMENTRY,74

.set TS_RUN,2
.set TS_READY,3
.set TS_WAIT,4
.set TS_REMOVED,6
.set TS_CHANGING,7
.set TS_ATOMIC,8

.set TASKPPC_SYSTEM,0
.set TASKPPC_BAT,1
.set TASKPPC_EMULATOR,2
.set TASKPPC_CHOWN,3
.set TASKPPC_ATOMIC,5

.set TASKPPC_STACKSIZE,92				#Problems here when programs use the non-private parts of this structure
.set TASKPPC_STACKMEM,96
.set TASKPPC_CONTEXTMEM,100
.set TASKPPC_TASKPTR,104
.set TASKPPC_FLAGS,108
.set TASKPPC_LINK,112
.set TASKLINK_TASK,120

.set TASKLINK_SIG,12
.set TASKLINK_USED,16

.set TASKPPC_BATSTORAGE,130
.set TASKPPC_PAD,154
.set TASKPPC_TIMESTAMP,156
.set TASKPPC_TIMESTAMP2,160
.set TASKPPC_ELAPSED,164
.set TASKPPC_ELAPSED2,168
.set TASKPPC_PRIORITY,180
.set TASKPPC_PRIOFFSET,184
.set TASKPPC_POWERPCBASE,188
.set TASKPPC_DESIRED,192
.set TASKPPC_CPUUSAGE,196
.set TASKPPC_BUSY,200
.set TASKPPC_ACTIVITY,204
.set TASKPPC_ID,208
.set TASKPPC_NICE,212
.set TASKPPC_QUANTUM,176
.set TASKPPC_DESIRED,192
.set TASKPPC_ID,208
.set TASKPPC_MSGPORT,216
.set TASKPPC_TASKPOOLS,220
.set TASKPPC_POOLMEM,238
.set TASKPPC_MESSAGERIP,242
.set TASKPPC_SIZE,248

.set SYS_SIGALLOC,0xFFFF

.set T_PROCTIME,1

#Various defines
.set SS_NESTCOUNT,14
.set SS_WAITQUEUE,16
.set SS_OWNER,40
.set SS_QUEUECOUNT,44
.set SSPPC_SUCCESS,-1
.set SSPPC_NOMEM,0
.set SSPPC_RESERVE,46
.set SSPPC_LOCK,50
.set SSPPC_SIZE,52

.set PA_SIGNAL,0
.set PF_ACTION,3

.set UNIPORT_SUCCESS,-1
.set UNIPORT_NOTUNIQUE,0
.set UNISEM_SUCCESS,-1
.set UNISEM_NOTUNIQUE,0

.set PUBMSG_SUCCESS,-1
.set PUBMSG_NOPORT,0

.set SIGB_SINGLE,4
.set SIGF_SINGLE,16
.set SIGB_DOS,8
.set SIGF_DOS,256
.set SIGF_WAIT,1024

.set MP_FLAGS,14
.set MP_SIGBIT,15
.set MP_SIGTASK,16
.set MP_MSGLIST,20
.set MP_PPC_INTMSG,34
.set MP_PPC_SEM,48

.set pr_MsgPort,92
.set pr_CLI,172
.set cli_CommandName,16

.set MN_REPLYPORT,14
.set MN_LENGTH,18
.set MN_SIZE,20

.set MH_ATTRIBUTES,14			# characteristics of this region
.set MH_FIRST,16			# first free region
.set MH_LOWER,20			# lower memory bound
.set MH_UPPER,24			# upper memory bound+1
.set MH_FREE,28				# number of free bytes
.set MH_SIZE,32

.set ME_ADDR,0
.set ME_LENGTH,4

.set ML_NUMENTRIES,14
.set ML_SIZE,16

.set MC_NEXT,0
.set MC_BYTES,4

.set PP_CODE,0
.set PP_OFFSET,4
.set PP_FLAGS,8
.set PP_STACKPTR,12
.set PP_STACKSIZE,16
.set PP_REGS,20
.set PP_FREGS,80
.set PP_SIZE,144
.set PPB_ASYNC,0
.set PPB_LINEAR,1
.set PPB_THROW,2
.set PPF_ASYNC,1
.set PPF_LINEAR,2
.set PPF_THROW,4

.set PPERR_SUCCESS,0
.set PPERR_ASYNCERR,1
.set PPERR_WAITERR,2

.set ATTEMPT_SUCCESS,-1
.set ATTEMPT_FAILURE,0

.set CMP_EQUAL,0
.set CMP_DESTGREATER,-1
.set CMP_DESTLESS,1

.set MLH_HEAD,0

.set LH_TAILPRED,8
.set LH_HEAD,0
.set LH_TAIL,4

.set SNOOP_CODE,0x80103000
.set SNOOP_DATA,0x80103001
.set SNOOP_TYPE,0x80103002
.set SNOOP_START,1
.set SNOOP_EXIT,2

.set SSM_SEMAPHORE,20

.set TV_SECS,0
.set TV_MICRO,4

.set WAITTIME_TIME1,14
.set WAITTIME_TIME2,18
.set WAITTIME_TASK,22

.set TAG_DONE,0
.set MEMERR_SUCCESS,0
.set FALSE,0
.set TRUE,1

.set RTF_AUTOINIT,0x80
.set RTF_NATIVE,0x20

.set RTC_MATCHWORD,0x4afc

.set CLT_DataSize,			0x8000000a
.set CLT_InitFunc,			0x80000003
.set CLT_Interfaces,			0x80000009
.set CLT_Vector68K,			0x80000001

.set MIT_Name,				0x80000009
.set MIT_VectorTable,			0x80000001
.set MIT_Version,			0x80000006

.set GCIT_Model,			0x80000003
.set GCIT_FrontSideSpeed,		0x80000007
.set GCIT_ProcessorSpeed,		0x80000008

.set ASOT_PORT,			6
.set ASOT_IOREQUEST,		0
.set ASOT_INTERRUPT,		2

.set ASO_NoTrack,			0x80000001
.set ASOIOR_ReplyPort,			0x8000000b
.set ASOIOR_Size,			0x8000000a
.set ASOPORT_Size,			0x8000000a
.set ASOINTR_Code,			0x8000000b
.set ASOINTR_Data,			0x8000000c

.set GMIT_Machine,0x80000001
.set MACHINETYPE_UNKNOWN,	0
.set MACHINETYPE_AMIGAONE,	3
.set MACHINETYPE_SAM440,	4
.set MACHINETYPE_PEGASOSII,	5
.set MACHINETYPE_X1000,		6
.set MACHINETYPE_SAM460,	7
.set MACHINETYPE_X5000_20,	9
.set MACHINETYPE_X5000_40,	10

.set CPUTYPE_UNKNOWN,		0
.set CPUTYPE_603E,		1
.set CPUTYPE_604E,		2

.set PPCSTATEF_APPACTIVE,	2
.set PPCSTATEF_APPRUNNING,	4

.set TRAPNUM_INST_SEGMENT_VIOLATION,	0x0300
.set TRAPNUM_ALIGNMENT,			0x0400

.set is_Code,			18
.set is_Data,			14

.set ECF_FULL_GPRS,1<<0
.set ECF_FPU,1<<1
.set ECF_FULL_FPU,1<<2

.set ExceptionContext_Flags,0
.set ExceptionContext_ip,12
.set ExceptionContext_gpr,16
.set ExceptionContext_lr,144
.set ExceptionContext_xer,148
.set ExceptionContext_ctr,152
.set ExceptionContext_lr,156
.set ExceptionContext_dsisr,160
.set ExceptionContext_dar,164
.set ExceptionContext_fpr,168
.set TLB_VALID,0x200
.set TLB_EPN,21
.set TLB_UX,0x20
.set TLB_SX,0x04
.set MAS3_UX,0x20
.set MAS3_SX,0x10
.set MAS1_VALID,			0x80000000

.set io_Device,			20
.set io_Command,		28
.set io_Actual,			32
.set io_Length,			36

.set TR_ADDREQUEST,		9
.set UNIT_MICROHZ,		0

