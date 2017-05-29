
.include	ppcdefines.i
.include	emulation.i
.include	ppcmacros-std.i
.include	interfaces.i

#.set __amigaos4__,0

#********************************************************************************************

		.text

#********************************************************************************************
		
_start:
		li	r3,20
		blr

#********************************************************************************************

INITFUNC:	#r3 = base, r4 = seglist, r5 = exec interface

		prolog
		
		stwu	r11,-4(r13)
		stwu	r12,-4(r13)
		stwu	r14,-4(r13)
		stwu	r15,-4(r13)
		stwu	r16,-4(r13)
		stwu	r17,-4(r13)
		stwu	r18,-4(r13)
		stwu	r19,-4(r13)
		stwu	r20,-4(r13)
		stwu	r21,-4(r13)
		stwu	r22,-4(r13)
		stwu	r23,-4(r13)
		stwu	r24,-4(r13)
		stwu	r25,-4(r13)
		stwu	r26,-4(r13)
		stwu	r27,-4(r13)
		stwu	r28,-4(r13)
		stwu	r29,-4(r13)
		stwu	r30,-4(r13)
		stwu	r31,-4(r13)
		
		ldaddr	r9,LibName
		lis	r11,WarpLibBase@ha
		stw	r3,WarpLibBase@l(r11)
		li	r0,NT_LIBRARY
		stw	r4,libwarp_SegList(r3)
		stb	r0,LN_TYPE(r3)
		li	r0,LIBF_SUMUSED|LIBF_CHANGED
		stw	r9,LN_NAME(r3)
		li	r9,18
		li	r11,0
		sth	r9,lib_Version(r3)
		lis	r9,IDString@ha
		stb	r0,lib_Flags(r3)
		addi	r9,r9,IDString@l
		li	r0,0
		stb	r11,LN_PRI(r3)
		stb	r0,libwarp_CacheFlag(r3)
		sth	r0,lib_Revision(r3)		
		stw	r9,lib_IdString(r3)
		stw	r5,libwarp_IExec(r3)
		mr	r31,r3
		mr	r29,r5
		
		la	r4,libwarp_PortSem(r3)
		CALLOS	r29,InitSemaphore
		
		la	r4,libwarp_SemSem(r31)
		CALLOS	r29,InitSemaphore
		
		la	r4,libwarp_MemSem(r31)
		CALLOS	r29,InitSemaphore
		
		la	r4,libwarp_MemList(r31)
		CALLOS	r29,NewMinList
		
		la	r4,libwarp_TaskList(r31)
		CALLOS	r29,NewMinList
		
		li	r4,ASOT_PORT
		loadreg	r5,ASO_NoTrack
		stw	r5,8(r1)
		li	r5,FALSE
		stw	r5,12(r1)
		stw	r5,16(r1)
		CALLOS	r29,AllocSysObjectTags

		mr.	r25,r3
		beq	.ErrorExp
		
		li	r4,ASOT_IOREQUEST
		loadreg	r5,ASO_NoTrack
		stw	r5,8(r1)
		li	r5,FALSE
		stw	r5,12(r1)
		stw	r5,32(r1)
		loadreg	r5,ASOIOR_ReplyPort
		stw	r5,16(r1)
		stw	r25,20(r1)
		loadreg	r5,ASOIOR_Size
		stw	r5,24(r1)
		li	r5,40
		stw	r5,28(r1)
		CALLOS	r29,AllocSysObjectTags
		
		mr.	r25,r3
		beq	.ErrorExp
		
		ldaddr	r4,TimerDev
		li	r5,UNIT_MICROHZ
		mr	r6,r25
		li	r7,0
		CALLOS	r29,OpenDevice
		
		mr.	r24,r3
		bne	.ErrorExp
		
		ldaddr	r27,MainName
		lwz	r4,io_Device(r25)
		mr	r5,r27
		li	r6,1
		li	r7,0
		CALLOS	r29,GetInterface
		
		stw	r3,libwarp_ITimer(r31)
		mr.	r23,r3
		beq	.ErrorExp
		
		la	r4,libwarp_StartTimeVal(r31)
		CALLOS	r23,GetSysTime
		
		ldaddr	r4,DosLib
		li	r5,52
		CALLOS	r29,OpenLibrary
		mr.	r28,r3
		beq	.ErrorExp
		
		mr	r4,r28
		mr	r5,r27
		li	r6,1
		li	r7,0
		CALLOS	r29,GetInterface
		mr.	r28,r3
		beq	.ErrorExp
		stw	r28,libwarp_IDOS(r31)		
						
		ldaddr	r4,UtilLib
		li	r5,52
		CALLOS	r29,OpenLibrary
		mr.	r28,r3
		beq	.ErrorExp
		
		mr	r4,r28
		mr	r5,r27
		li	r6,1
		li	r7,0
		CALLOS	r29,GetInterface
		mr.	r28,r3
		beq	.ErrorExp
		stw	r28,libwarp_IUtility(r31)

		ldaddr	r4,ExpLib
		li	r5,52
		CALLOS	r29,OpenLibrary
		
		mr.	r28,r3
		beq	.ErrorExp
		
		mr	r4,r28
		mr	r5,r27
		li	r6,1
		li	r7,0
		CALLOS	r29,GetInterface
		
		mr.	r26,r3
		beq	.ErrorIntExp
		loadreg	r0,GMIT_Machine
		addi	r14,r1,20
		stw	r0,8(r1)
		li	r0,0
		stw	r14,12(r1)
		stw	r0,16(r1)
		CALLOS	r26,GetMachineInfoTags
		
		mr	r4,26
		CALLOS	r29,DropInterface
		
		lwz	r14,20(r1)
		cmpwi	r14,MACHINETYPE_UNKNOWN
		beq	.ErrorIntExp
		cmpwi	r14,MACHINETYPE_AMIGAONE
		ble	.PPC600Setup
		cmpwi	r14,MACHINETYPE_SAM440
		beq	.PPC400Setup
		cmpwi	r14,MACHINETYPE_PEGASOSII
		beq	.PPC600Setup
		cmpwi	r14,MACHINETYPE_X1000
		beq	.PPC600Setup
		cmpwi	r14,MACHINETYPE_SAM460
		beq	.PPC400Setup
		cmpwi	r14,MACHINETYPE_X5000_20
		beq	.PPC500Setup
		cmpwi	r14,MACHINETYPE_X5000_40
		beq	.PPC500Setup
		b	.ErrorIntExp
		
.ErrorIntExp:	mr	r4,r28
		CALLOS	r29,CloseLibrary
		
.ErrorExp:	mr	r3,r31
		lwz	r31,0(r13)
		lwz	r30,4(r13)
		lwz	r29,8(r13)
		lwz	r28,12(r13)
		lwz	r27,16(r13)
		lwz	r26,20(r13)
		lwz	r25,24(r13)
		lwz	r24,28(r13)
		lwz	r23,32(r13)
		lwz	r22,36(r13)
		lwz	r21,40(r13)
		lwz	r20,44(r13)
		lwz	r19,48(r13)
		lwz	r18,52(r13)
		lwz	r17,56(r13)
		lwz	r16,60(r13)
		lwz	r15,64(r13)
		lwz	r14,68(r13)
		lwz	r12,72(r13)
		lwz	r11,76(r13)
		addi	r13,r13,80
		
		epilog

#********************************************************************************************

.PPC600Setup:	
		li	r14,MACHF_PPC600LIKE
		stw	r14,libwarp_MachineFlag(r31)
		
		CALLOS	r29,Enable
		
		CALLOS	r29,SuperState
		
		mfsr    r0,0
		stw     r0,libwarp_sr0(r31)				#load original mmu values
		mfsr    r14,1
		stw     r14,libwarp_sr1(r31)
		mfsr    r0,2
		stw     r0,libwarp_sr2(r31)
		mfsr    r14,3
		stw     r14,libwarp_sr3(r31)
		mfsr    r0,4
		stw     r0,libwarp_sr4(r31)
		mfsr    r14,5
		stw     r14,libwarp_sr5(r31)
		mfsr    r0,6
		stw     r0,libwarp_sr6(r31)
		mfsr    r14,7
		stw     r14,libwarp_sr7(r31)
		mr.	r4,r3
		beq	.KeepSupr
		
		CALLOS	r29,UserState
		
.KeepSupr:	CALLOS	r29,Enable

		b	.ErrorIntExp

#********************************************************************************************

.PPC400Setup:	
		li	r14,MACHF_PPC400LIKE
		stw	r14,libwarp_MachineFlag(r31)
		b	.ErrorIntExp
		
#********************************************************************************************		
		
.PPC500Setup:	
		li	r14,MACHF_PPC500LIKE
		stw	r14,libwarp_MachineFlag(r31)
		b	.ErrorIntExp
		
#********************************************************************************************

.ItsPPC600:	
		subi	r29,r28,1
		CALLOS	r30,Disable
		
		CALLOS	r30,SuperState
		
		loadreg	r0,~SR_NO_EXECUTE
		or      r29,r29,r0
		
		lwz     r0,libwarp_sr0(r31)			#r31=base
		and     r0,r29,r0
		isync
		mtsr    0,r0
		sync    
		isync
		lwz     r9,libwarp_sr1(r31)
		and     r9,r29,r9
		isync
		mtsr    1,r9
		sync    
		isync
		lwz     r0,libwarp_sr2(r31)
		and     r0,r29,r0
		isync
		mtsr    2,r0
		sync    
		isync
		lwz     r9,libwarp_sr3(r31)
		and     r9,r29,r9
		isync
		mtsr    3,r9
		sync    
		isync
		lwz     r0,libwarp_sr4(r31)
		and     r0,r29,r0
		isync
		mtsr    4,r0
		sync    
		isync
		lwz     r9,libwarp_sr5(r31)
		and     r9,r29,r9
		isync
		mtsr    5,r9
		sync    
		isync
		lwz     r0,libwarp_sr6(r31)
		and     r0,r29,r0
		isync
		mtsr    6,r0
		sync    
		isync
		lwz     r9,libwarp_sr7(r31)
		and     r29,r29,r9
		isync
		mtsr    7,r29
		sync    
		isync
		
		mr.	r4,r3
		beq	.KeepSuper
		CALLOS	r30,UserState
     
.KeepSuper:	CALLOS	r30,Enable
		mr.	r28,r28
		beq	.GoBackClose
		b	.GoExitOpen

#********************************************************************************************
		
ExceptionHandler:
		lis	r0,TRAPNUM_INST_SEGMENT_VIOLATION
		cmpw	r5,r0
		beq	.ItsAnISI
		lis	r0,TRAPNUM_ALIGNMENT
		cmpw	r5,r0
		beq	.ItsAlignment
		li	r3,0
.ExcExit:	blr
		
#***********************************************
		
.ItsAnISI:	lwz	r9,ExceptionContext_ip(r3)
		rlwinm.	r7,r9,0,0,19
		li	r3,0
		beq	.ExcExit
		lis	r7,WarpLibBase@ha
		lwz	r7,WarpLibBase@l(r7)
		lwz	r7,libwarp_MachineFlag(r7)
		cmpwi	r7,MACHF_PPC500LIKE
		lwz	r7,0(r9)				#Force TLB update
		beq	.ISIPPC500
		
		tlbsx.	r7,r0,r9
		bne	.ExcExit
		tlbre	r5,r7,2
		ori	r5,r5,TLB_UX|TLB_SX
		tlbwe 	r5,r7,2		
		li	r3,1
		blr
		
#***********************************************
	
.ISIPPC500:	mfmsr	r4
		rlwinm	r5,r4,27,31,31				#Get MSR[IS]
		mfspr	r4,PID0
		slwi	r4,r4,16
		or	r4,r4,r5
		mtspr	MAS6,r4
		isync
		tlbsx	r0,r0,r9
		mfspr	r4,MAS1
		andis.	r4,r4,MAS1_VALID@h
		bne	.GotTBL
		mfspr	r4,PID1
		slwi	r4,r4,16
		or	r4,r4,r5
		mtspr	MAS6,r4
		isync
		tlbsx	r0,r0,r9
		mfspr	r4,MAS1
		andis.	r4,r4,MAS1_VALID@h
		bne	.GotTBL
		mfspr	r4,PID2
		slwi	r4,r4,16
		or	r4,r4,r5
		mtspr	MAS6,r4
		isync
		tlbsx	r0,r0,r9				#Should be tlbsx r0,r9 in BookE
		mfspr	r4,MAS1
		andis.	r4,r4,MAS1_VALID@h
		beq	.ExcExit
.GotTBL:	mfspr	r4,MAS3
		ori	r4,r4,MAS3_UX|MAS3_SX
		mtspr	MAS3,r4
		isync
		tlbwe	r0,r0,0					#Should be tlbwe in BookE
		li	r3,1
		blr
		
#***********************************************		
		
.ItsAlignment:	lwz	r6,ExceptionContext_Flags(r3)
		rlwinm	r6,r6,0,30,31
		cmpwi	r6,3
		bne	.NextHandler

		la	r4,ExceptionContext_fpr(r3)		#Start of fp regtable in r4
		la	r11,ExceptionContext_gpr(r3)		#Start of gp regtable in r11
		lis	r12,AlignSpot@ha
		lwz	r5,ExceptionContext_ip(r3)
		lwz	r5,0(r5)

		rlwinm	r6,r5,14,24,28				#get floating point register offset
		rlwinm	r7,r5,18,25,29				#get destination register offset
		mr.	r10,r7
		beq	.ItsR0
		lwzx	r10,r11,r7				#get address from destination register
.ItsR0:		rlwinm	r8,r5,0,16,31				#get displacement

		rlwinm	r0,r5,6,26,31		
		cmpwi	r0,0x34					#test for stfs
		beq	.stfs
		cmpwi	r0,0x35
		beq	.stfsu
		cmpwi	r0,0x30
		beq	.lfs
		cmpwi	r0,0x31
		beq	.lfsu
		cmpwi	r0,0x1f
		beq	.lstfsx
		cmpwi	r0,0x32
		beq	.lfd
		cmpwi	r0,0x36
		beq	.stfd
		b	.NextHandler

.stfd:		lwzx	r9,r4,r6
		stwx	r9,r10,r8
		addi	r6,r6,4
		addi	r8,r8,4
		lwzx	r9,r4,r6
		stwx	r9,r10,r8
		b	.AligExit

.stfsu:		add	r9,r10,r8
		stwx	r9,r11,r7

.stfs:		lfdx	f1,r4,r6				#get value from fp register
		stfs	f1,AlignSpot@l(r12)			#store it on correct aligned spot
		lwz	r6,AlignSpot@l(r12)			#Get the correct 32 bit value
		stwx	r6,r10,r8				#Store correct value
		b	.AligExit

.lfd:		lwzx	r9,r10,r8
		stw	r9,AlignSpot@l(r12)
		addi	r8,r8,4
		lwzx	r9,r10,r8
		stw	r9,4+AlignSpot@l(r12)
		lfd	f1,AlignSpot@l(r12)
		stfdx	f1,r4,r6
		b	.AligExit

.lfsu:		add	r5,r10,r8				#Add displacement
		stwx	r5,r11,r7	

.lfs:		lwzx	r9,r10,r8				#Get 32 bit value
		stw	r9,AlignSpot@l(r12)			#Store it on aligned spot
		lfs	f1,AlignSpot@l(r12)			#Get it and convert it to 64 bit
		stfdx	f1,r4,r6				#Store the 64 bit value
		b	.AligExit
		
.lstfsx:	rlwinm	r8,r5,23,25,29				#get index register
		lwzx	r8,r11,r8				#get index register value
		rlwinm.	r0,r5,24,31,31
		bne	.stfs
		b	.lfs
		
.NextHandler:	li	r3,0
		blr

.AligExit:	lwz	r5,ExceptionContext_ip(r3)
		addi	r5,r5,4
		stw	r5,ExceptionContext_ip(r3)	
		li	r3,1
		blr

#********************************************************************************************	

.UnSupported:						#Function(r27)
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		
		lwz	r31,libwarp_IExec(r30)		
		ldaddr	r30,UnSupportedString
		
		li	r4,0
		CALLOS	r31,FindTask
		
		lwz	r28,LN_NAME(r3)	
		lwz	r29,pr_CLI(r3)
		mr.	r29,r29
		beq	.NoCLI3
		
		rlwinm	r29,r29,2,0,31
		lwz	r29,cli_CommandName(r29)
		mr.	r29,r29
		beq	.NoCLI3
		
		rlwinm	r28,r29,2,0,31
		addi	r28,r28,1
				
.NoCLI3:	stw	r27,12(r1)
		stw	r28,8(r1)
		mr	r4,r30
		CALLOS	r31,DebugPrintF
		
		lwz	r28,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16
		
		epilog
				
#********************************************************************************************

IObtain:
		mr	r9,r3
		lwz 	r3,Data_RefCount(r9)
		addi	r3,r3,1
		stw	r3,Data_RefCount(r9)
		blr

#********************************************************************************************

IRelease:
		mr	r9,r3
		lwz	r3,Data_RefCount(r9)
		subi	r3,r3,1
		stw	r3,Data_RefCount(r9)
		blr

#********************************************************************************************

IOpen:		
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)

		lwz	r31,Data_LibBase(r3)
		lwz	r30,libwarp_IExec(r31)
		
		li	r4,0		
		stw	r4,libwarp_CachedTask(r31)
		li	r5,-1
		li	r6,CACRF_ClearI
		
		CALLOS	r30,CacheClearE
				
		lhz	r9,lib_OpenCnt(r31)
		addi	r9,r9,1
		sth	r9,lib_OpenCnt(r31)
		cmpwi	r9,1
		bne	.GoExitOpen

		lwz	r4,libwarp_MachineFlag(r31)
		mr.	r4,r4
		li	r28,1
		beq	.ItsPPC600
			
.GoExitOpen:	mr	r3,r31

		lwz	r28,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16

		epilog

#********************************************************************************************

IClose:			
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		
		lwz	r31,Data_LibBase(r3)
		lwz	r30,libwarp_IExec(r31)
		
		lhz	r9,lib_OpenCnt(r31)
		subi	r9,r9,1
		sth	r9,lib_OpenCnt(r31)
		cmpwi	r9,0
		li	r3,0
		bne	.GoExitClose
		
		lwz	r4,libwarp_MachineFlag(r31)
		mr.	r4,r4
		li	r28,0
		beq	.ItsPPC600
		
.GoBackClose:	lbz	r0,lib_Flags(r31)
		andi.	r9,r0,LIBF_DELEXP
		li	r3,0
		beq	.GoExitClose
		
		nop
		
.GoExitClose:	li	r3,0
		lwz	r28,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16
		
		epilog

#********************************************************************************************

IExpunge:
		li	r3,0
		blr

#********************************************************************************************
#********************************************************************************************

Open68K:	
		li	r3,0
		blr

#********************************************************************************************

Close68K:

		li	r3,0
		blr

#********************************************************************************************

Expunge68K:

		li	r3,0
		blr

#********************************************************************************************

Reserved68K:

		li	r3,0
		blr

#********************************************************************************************
#
#		REG68K_D0	=	RunPPC68K (REG68K_A0)	//	68K reg struct in r3
#
#********************************************************************************************
RunPPC68K:
		prolog
		
		stwu	r2,-4(r13)
		stwu	r16,-4(r13)
		stwu	r17,-4(r13)
		stwu	r11,-4(r13)
		stwu	r12,-4(r13)
		stwu	r14,-4(r13)
		stwu	r15,-4(r13)
		stwu	r18,-4(r13)
		stwu	r19,-4(r13)
		stwu	r20,-4(r13)
		stwu	r21,-4(r13)
		stwu	r22,-4(r13)
		stwu	r23,-4(r13)
		stwu	r24,-4(r13)
		stwu	r25,-4(r13)
		stwu	r26,-4(r13)
		stwu	r27,-4(r13)
		stwu	r28,-4(r13)
		stwu	r29,-4(r13)
		stwu	r30,-4(r13)
		stwu	r31,-4(r13)
		
		lwz	r16,REG68K_A0(r3)
		lwz	r3,REG68K_A6(r3)
	
.SNewProc:	lwz	r31,libwarp_IExec(r3)
		mr	r26,r3
		
		lwz	r17,PP_FLAGS(r16)
		andi.	r0,r17,PPF_ASYNC|PPF_THROW
		bne	.NotStandard
		
		lis     r4,TRAPNUM_ALIGNMENT
		ldaddr	r5,ExceptionHandler
		lis     r6,TRAPNUM_ALIGNMENT
		CALLOS	r31,SetTaskTrap

		lwz	r4,libwarp_MachineFlag(r26)
		mr.	r4,r4
		beq	.NoTrapSet
		
		lis     r4,TRAPNUM_INST_SEGMENT_VIOLATION
		ldaddr	r5,ExceptionHandler
		lis     r6,TRAPNUM_INST_SEGMENT_VIOLATION
		CALLOS	r31,SetTaskTrap	
				
.NoTrapSet:	lwz	r27,libwarp_CachedTask(r26)
		li	r4,0
		CALLOS	r31,FindTask
		cmpw	r3,r27
		stw	r3,libwarp_CachedTask(r26)
		stwu	r26,-4(r13)
		stwu	r31,-4(r13)
		stwu	r16,-4(r13)
		beq	.NoFlushNeeded
		
		li	r4,0
		li	r5,-1
		li	r6,CACRF_ClearI
		
		CALLOS	r31,CacheClearE
		
.NoFlushNeeded:	lwz	r3,PP_REGS+0*4(r16)
		lwz	r4,PP_REGS+1*4(r16)
		lwz	r22,PP_REGS+2*4(r16)
		lwz	r23,PP_REGS+3*4(r16)
		lwz	r24,PP_REGS+4*4(r16)
		lwz	r25,PP_REGS+5*4(r16)
		lwz	r26,PP_REGS+6*4(r16)
		lwz	r27,PP_REGS+7*4(r16)
		lwz	r5,PP_REGS+8*4(r16)
		lwz	r6,PP_REGS+9*4(r16)
		lwz	r28,PP_REGS+10*4(r16)
		lwz	r29,PP_REGS+11*4(r16)
		lwz	r2,PP_REGS+12*4(r16)
		lwz	r30,PP_REGS+13*4(r16)
		lwz	r31,PP_REGS+14*4(r16)
		
		andi.	r0,r17,PPF_LINEAR
		beq	.NotLinear
		
		mr	r5,r22
		mr	r6,r23
		mr	r7,r24
		mr	r8,r25
		mr	r9,r26
		mr	r10,r27
		
.NotLinear:	lfd	f1,PP_FREGS+0*8(r16)			#Perform FPU test here
		lfd	f2,PP_FREGS+1*8(r16)
		lfd	f3,PP_FREGS+2*8(r16)
		lfd	f4,PP_FREGS+3*8(r16)
		lfd	f5,PP_FREGS+4*8(r16)
		lfd	f6,PP_FREGS+5*8(r16)
		lfd	f7,PP_FREGS+6*8(r16)
		lfd	f8,PP_FREGS+7*8(r16)
		
		lwz	r17,PP_CODE(r16)
		lwz	r18,PP_OFFSET(r16)
		mr.	r18,r18
		beq	.JustCode
		
		add	r17,r17,r18
		lwz	r17,2(r17)				#Get jump		
		
.JustCode:	mtlr	r17
		stw	r2,20(r1)
		lwz	r17,0(r17)				#Force TBL load
		stw	r13,100(r1)
		
		blrl

		lwz	r13,100(r1)
		lwz	r16,0(r13)
		lwz	r17,PP_FLAGS(r16)
		andi.	r0,r17,PPF_LINEAR
		beq	.NotLinear2

		mr	r22,r5
		mr	r23,r6
		mr	r24,r7
		mr	r25,r8
		mr	r26,r9
		mr	r27,r10
		
.NotLinear2:	stw	r3,PP_REGS+0*4(r16)
		stw	r4,PP_REGS+1*4(r16)
		stw	r22,PP_REGS+2*4(r16)
		stw	r23,PP_REGS+3*4(r16)
		stw	r24,PP_REGS+4*4(r16)
		stw	r25,PP_REGS+5*4(r16)
		stw	r26,PP_REGS+6*4(r16)
		stw	r27,PP_REGS+7*4(r16)
		stw	r5,PP_REGS+8*4(r16)
		stw	r6,PP_REGS+9*4(r16)
		stw	r28,PP_REGS+10*4(r16)
		stw	r29,PP_REGS+11*4(r16)
		stw	r2,PP_REGS+12*4(r16)
		stw	r30,PP_REGS+13*4(r16)
		stw	r31,PP_REGS+14*4(r16)
		
		stfd	f1,PP_FREGS+0*8(r16)			#Perform FPU test here
		stfd	f2,PP_FREGS+1*8(r16)
		stfd	f3,PP_FREGS+2*8(r16)
		stfd	f4,PP_FREGS+3*8(r16)
		stfd	f5,PP_FREGS+4*8(r16)
		stfd	f6,PP_FREGS+5*8(r16)
		stfd	f7,PP_FREGS+6*8(r16)
		stfd	f8,PP_FREGS+7*8(r16)
		
		lwz	r31,4(r13)
		lwz	r30,8(r13)
		addi	r13,r13,12	
								
.NoTrapRemove:	li	r3,PPERR_SUCCESS
		b	.ExitRunPPC		
		
.NotStandard:	li	r3,PPERR_ASYNCERR

.ExitRunPPC:	lwz	r31,0(r13)
		lwz	r30,4(r13)
		lwz	r29,8(r13)
		lwz	r28,12(r13)
		lwz	r27,16(r13)
		lwz	r26,20(r13)
		lwz	r25,24(r13)
		lwz	r24,28(r13)
		lwz	r23,32(r13)
		lwz	r22,36(r13)
		lwz	r21,40(r13)
		lwz	r20,44(r13)
		lwz	r19,48(r13)
		lwz	r18,52(r13)
		lwz	r15,56(r13)
		lwz	r14,60(r13)
		lwz	r12,64(r13)
		lwz	r11,68(r13)
		lwz	r17,72(r13)
		lwz	r16,76(r13)
		lwz	r2,80(r13)
		addi	r13,r13,84
		
		epilog

#********************************************************************************************

WaitForPPC68K:
		li	r3,PPERR_SUCCESS
		blr

#********************************************************************************************

GetCPU68K:
		prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		loadreg	r0,GCIT_Model
		lwz     r31,REG68K_A6(r3)
		lwz     r31,libwarp_IExec(r31)
		addi    r30,r1,24
		stw     r0,8(r1)
		li      r0,0
		stw     r30,12(r1)
		stw	r0,16(r1)
		CALLOS	r31,GetCPUInfoTags
		
		lwz     r0,24(r1)
		cmpwi	r0,CPUTYPE_PPC603E
		li	r3,CPUF_603E
		beq	.FoundCPU
		cmpwi	r0,CPUTYPE_PPC604E
		loadreg	r3,CPUF_604E
		beq	.FoundCPU
		li	r3,0

.FoundCPU:	lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

PowerDebugMode68K:
		blr

#********************************************************************************************

AllocVec3268K:
		prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		lwz	r31,REG68K_A6(r3)
		loadreg	r5,MEMF_CLEAR|MEMF_CHIP|MEMF_REVERSE
		lwz	r0,REG68K_D1(r3)
		lwz	r4,REG68K_D0(r3)
		and	r5,r0,r5
		lwz	r30,libwarp_IExec(r31)
		CALLOS	r30,AllocVec
			
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

FreeVec3268K:
		prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		lwz	r31,REG68K_A6(r3)
		lwz	r4,REG68K_A1(r3)
		lwz	r30,libwarp_IExec(r31)	
		CALLOS	r30,FreeVec
				
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SPrintF68K68K:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		
		lwz	r31,REG68K_A6(r3)
		lwz	r30,libwarp_IExec(r31)
		lwz	r29,libwarp_IUtility(r31)
		
		lwz	r4,REG68K_A0(r3)
		lwz	r5,REG68K_A1(r3)
		
		CALLOS	r29,VASPrintf
		
		mr.	r31,r3
		beq	.SPrintExit
		
		mr	r4,r31
		
		CALLOS	r30,DebugPrintF
		
		mr	r4,r31
		
		CALLOS	r30,FreeVec
		
.SPrintExit:	lwz	r29,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

AllocXMsg68K:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r26,-4(r13)
		stwu	r25,-4(r13)
		
		lwz	r30,REG68K_A6(r3)
		lwz	r29,REG68K_D0(r3)
		lwz	r31,libwarp_IExec(r30)
		addi	r28,r29,MN_SIZE
		lwz	r25,REG68K_A0(r3)				
		CALLOS	r31,AllocVec
		mr.	r26,r3		
		beq	.NoXMem
		
		sth	r28,MN_LENGTH(r26)
		stw	r25,MN_REPLYPORT(r26)

.NoXMem:	lwz	r25,0(r13)
		lwz	r26,4(r13)
		lwz	r28,8(r13)
		lwz	r29,12(r13)
		lwz	r30,16(r13)
		lwz	r31,20(r13)
		addi	r13,r13,24
		
		epilog


#********************************************************************************************

FreeXMsg68K:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		lwz	r30,REG68K_A6(r3)
		lwz	r4,REG68K_A0(r3)
		lwz	r31,libwarp_IExec(r30)
		
		CALLOS	r31,FreeVec
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

PutXMsg68K:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		li	r0,NT_XMSG68K
		lwz	r30,REG68K_A6(r3)
		lwz	r5,REG68K_A1(r3)
		lwz	r31,libwarp_IExec(r30)
		lwz	r4,REG68K_A0(r3)
		stb	r0,LN_TYPE(r5)
		
		CALLOS	r31,PutMsg

		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

GetPPCState68K:
		li	r3,PPCSTATEF_APPRUNNING|PPCSTATEF_APPACTIVE
		blr

#********************************************************************************************

SetCache68K68K:
		blr

#********************************************************************************************

CreatePPCTask68K:
		lwz	r4,REG68K_A0(r3)
		lwz	r3,REG68K_A6(r3)
		b	CreateTaskPPC

#********************************************************************************************

CausePPCInterrupt68K:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FCausePPCInterrupt
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************
#********************************************************************************************

Run68K:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r27,-4(r13)
		stwu	r26,-4(r13)
		stwu	r25,-4(r13)
		
		mr	r31,r4
		mr	r30,r3
		li	r25,0
		
		lwz	r5,PP_OFFSET(r31)
		lwz	r6,PP_FLAGS(r31)
		lwz	r4,PP_CODE(r31)
		
		mr	r26,r4
		mr	r28,r5
		
		lwz	r29,libwarp_IExec(r30)
		mr.	r28,r28
		beq	.ReturnACheck
		
		lwz	r27,Data_LibBase(r29)
		cmpw	r27,r26
		beq	.CheckExec	
	
		lwz	r27,libwarp_IDOS(r30)
		lwz	r27,Data_LibBase(r27)
		cmpw	r27,r26
		beq	.CheckDOS
		
		lwz	r27,LN_NAME(r26)
		mr.	r27,r27
		beq	.ReturnACheck
		loadreg	r4,'lowl'
		lwz	r27,0(r27)
		cmpw	r4,r27
		beq	.CheckLow		
		
.ReturnACheck:	lwz	r27,PP_FLAGS(r31)
		mr.	r27,r27
		bne	.RunError68
		
		li	r4,0
		CALLOS	r29,FindTask
		
		lbz	r0,LN_TYPE(r3)
		cmpwi	r0,NT_PROCESS
		bne	.RunError68
		
		lwz	r28,Data_LibBase(r29)
		lwz	r4,EmuWS(r28)
		mr	r28,r4
		addi	r5,r1,144
		li	r6,128
		CALLOS	r29,CopyMem
		
		la	r4,PP_FREGS(r31)
		la	r5,REG68K_FP0(r28)
		li	r6,64
		CALLOS	r29,CopyMem
		
		la	r4,PP_REGS(r31)
		mr	r5,r28
		li	r6,60
		CALLOS	r29,CopyMem
		
		lwz	r4,PP_CODE(r31)
		loadreg	r27,ET_Offset
		stw	r27,8(r1)
		lwz	r27,PP_OFFSET(r31)
		stw	r27,12(r1)
		li	r27,0
		stw	r27,16(r1)	
		CALLOS	r29,EmulateTags

		stw	r3,PP_REGS(r31)
		la	r4,REG68K_D1(r28)
		la	r5,PP_REGS+1*4(r31)
		li	r6,56
		CALLOS	r29,CopyMem
		
		la	r4,REG68K_FP0(r28)
		la	r5,PP_FREGS(r31)
		li	r6,64
		CALLOS	r29,CopyMem
		
		addi	r4,r1,144
		mr	r5,r28
		li	r6,128
		CALLOS	r29,CopyMem

		mr.	r25,r25
		beq	.NoCacheClear

		CALLOS	r29,CacheClearU

.NoCacheClear:	li	r3,PPERR_SUCCESS
		b	.RunExit
		
.RunError68:	li	r3,3
				
.RunExit:	mr	r28,r3
		lwz	r3,PP_REGS(r31)
		mr	r3,r28
		
		lwz	r28,0(r1)
		lwz	r25,-8(r28)
		lwz	r26,0(r25)				#Force TBL load				
		
		lwz	r25,0(r13)
		lwz	r26,4(r13)
		lwz	r27,8(r13)
		lwz	r28,12(r13)
		lwz	r29,16(r13)
		lwz	r30,20(r13)
		lwz	r31,24(r13)
		addi	r13,r13,28

		epilog

.CheckExec:	lwz	r27,PP_OFFSET(r31)
		cmpwi	r27,_LVOOpenLibrary
		beq	.SetCFlag
		cmpwi	r27,_LVOOldOpenLibrary
		bne	.ReturnACheck
.SetCFlag:	li	r25,1
		b	.ReturnACheck

.CheckDOS:	lwz	r27,PP_OFFSET(r31)
		cmpwi	r27,_LVOLoadSeg
		beq	.SetCFlag
		cmpwi	r27,_LVODOSPrivate1
		beq	.SetCFlag
		cmpwi	r27,_LVOInternalLoadSeg
		beq	.SetCFlag
		cmpwi	r27,_LVONewLoadSeg
		beq	.SetCFlag
		b	.ReturnACheck
		
.CheckLow:	lwz	r27,PP_OFFSET(r31)
		cmpwi	r27,_LVOSetJoyPortAttrsA
		bne	.ReturnACheck
		
		lwz	r27,664(r26)		
		mr.	r27,r27
		beq	.RunError68
		b	.ReturnACheck
		
#********************************************************************************************

WaitFor68K:
		li	r3,PPERR_SUCCESS
		blr

#********************************************************************************************

SPrintF:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		
		lwz	r30,libwarp_IExec(r3)
		lwz	r29,libwarp_IUtility(r3)
		
		CALLOS	r29,VASPrintf
		
		mr.	r31,r3
		beq	.SPrintExit2
		
		mr	r4,r31
		
		CALLOS	r30,DebugPrintF
		
		mr	r4,r31
		
		CALLOS	r30,FreeVec
		
.SPrintExit2:	lwz	r29,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

Run68KLowLevel:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FRun68KLowLevel
		bl	.UnSupported		
		li	r3,3
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

AllocVecPPC:	
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		addi	r4,r4,32
		
		lwz	r31,libwarp_IExec(r30)
		loadreg	r0,MEMF_CLEAR|MEMF_CHIP|MEMF_REVERSE
		and	r5,r5,r0
		
		CALLOS	r31,AllocVec
		
		mr.	r29,r3
		beq	.MemError

		li	r4,0
		CALLOS	r31,FindTask
		
		stw	r3,8(r29)
		la	r4,libwarp_MemSem(r30)
		CALLOS	r31,ObtainSemaphore
		
		la	r4,libwarp_MemList(r30)
		mr	r5,r29
		CALLOS	r31,AddHead
		
		la	r4,libwarp_MemSem(r30)
		CALLOS	r31,ReleaseSemaphore
		
		addi	r3,r29,32
		
.MemError:	lwz	r27,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16
		
		epilog

#********************************************************************************************

FreeVecPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		subi	r29,r4,32
		
		lwz	r31,libwarp_IExec(r30)
		la	r4,libwarp_MemSem(r30)
		CALLOS	r31,ObtainSemaphore
		
		mr	r4,r29
		CALLOS	r31,Remove
		
		la	r4,libwarp_MemSem(r30)
		CALLOS	r31,ReleaseSemaphore
		
		mr	r4,r29
		CALLOS	r31,FreeVec
		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16
		
		epilog

#********************************************************************************************

CreateTaskPPC:

		prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r27,-4(r13)
		stwu	r26,-4(r13)
		stwu	r25,-4(r13)
		stwu	r24,-4(r13)
		stwu	r23,-4(r13)
		stwu	r22,-4(r13)
		stwu	r21,-4(r13)
		stwu	r20,-4(r13)
		stwu	r19,-4(r13)
		stwu	r18,-4(r13)
		stwu	r17,-4(r13)
		stwu	r16,-4(r13)

		stw	r4,200(r1)
		addi	r28,r1,200	
		
		lis	r16,1
		li	r21,0				#name
		li	r22,0				#pri_flag
		li	r23,0				#default pri
		li	r24,0				#code
		li	r25,0				#inherit_flag

		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		lwz	r29,libwarp_IUtility(r30)
		addi	r27,r1,100
		
		ldaddr	r19,JumpTable
		
.DoNextTag:	mr	r4,r28
		CALLOS	r29,NextTagItem
		mr.	r26,r3
		beq	.NoMoreTags
		
		lwz	r20,0(r26)
		subis	r0,r20,TASKATTR_CODE@h
		cmplwi	r0,21
		bgt	.DoNextTag
		
		rlwinm	r0,r0,2,0,29			#jumptable
		lwzx	r18,r19,r0
		mtctr	r18
		bctr
		
.NoMoreTags:	mr.	r24,r24
		bne	.GotCode
		
.ErrorCreate:	li	r3,0
		b	.ExitCreate		
		
.CorrectCreate:	mr	r29,r3
		loadreg	r5,MEMF_SHARED|MEMF_CLEAR
		li	r4,TASKPPC_MSGPORT+4
		CALLOS	r31,AllocVec
		
		lwz	r28,LN_NAME(r29)
		stw	r28,LN_NAME(r3)
		la	r28,pr_MsgPort(r29)
		stw	r28,TASKPPC_MSGPORT(r3)
		li	r28,NT_PROCESS
		stb	r28,LN_TYPE(r3)
		stw	r29,TASKPPC_TASKPTR(r3)
		mr	r28,r3
		li	r0,21
		mfctr	r4
		la	r29,8(r29)
		la	r3,8(r3)
		mtctr	r0
		
.CopyTask2:	lwzu	r0,4(r29)
		stwu	r0,4(r3)
		bdnz	.CopyTask2
		
		mtctr	r4
		la	r4,libwarp_TaskList(r30)
		mr	r5,r28
		CALLOS	r31,AddHead
		mr	r3,r28		
				
.ExitCreate:	lwz	r16,0(r13)
		lwz	r17,4(r13)
		lwz	r18,8(r13)
		lwz	r19,12(r13)
		lwz	r20,16(r13)
		lwz	r21,20(r13)
		lwz	r22,24(r13)
		lwz	r23,28(r13)
		lwz	r24,32(r13)
		lwz	r25,36(r13)
		lwz	r26,40(r13)
		lwz	r27,44(r13)
		lwz	r28,48(r13)
		lwz	r29,52(r13)
		lwz	r30,56(r13)
		lwz	r31,60(r13)
		addi	r13,r13,64
		
		epilog

#******************************************************	
	
.GotCode:	mr.	r21,r21				#NAME
		beq	.ErrorCreate
		
		lhz	r29,lib_OpenCnt(r30)
		addi	r29,r29,1
		sth	r29,lib_OpenCnt(r30)

		li	r4,256		
		loadreg	r5,MEMF_SHARED|MEMF_CLEAR	
		CALLOS	r31,AllocVec
		
		stw	r24,PP_CODE(r3)
		li	r0,PPF_LINEAR
		stw	r0,PP_FLAGS(r3)
		mfctr	r12
		li	r9,8
		mtctr	r9
		la	r10,PP_REGS-4(r3)
		mr	r11,r27
		
.CpRegs:	lwzu	r0,4(r11)
		stwu	r0,4(r10)
		bdnz	.CpRegs
		
		mtctr	r12
		lwz	r0,0(r27)
		stw	r0,PP_REGS+12*4(r3)
				
		loadreg	r6,NP_ENTRY
		loadreg	r7,NP_NAME
		loadreg	r8,NP_STACKSIZE
		loadreg	r9,NP_PRIORITY
		loadreg	r10,NP_ENTRYDATA
		loadreg	r11,NP_CHILD
		ldaddr	r12,NewProc
		
		stw	r6,8(r1)
		stw	r7,16(r1)
		stw	r8,24(r1)
		stw	r9,32(r1)
		li	r6,TRUE
		stw	r10,40(r1)
		stw	r11,48(r1)
		stw	r6,52(r1)
		li	r0,TAG_DONE
		stw	r12,12(r1)
		stw	r21,20(r1)
		stw	r16,28(r1)
		stw	r23,36(r1)
		stw	r3,44(r1)
		stw	r0,56(r1)
				
		lwz	r20,libwarp_IDOS(r30)
		CALLOS	r20,CreateNewProcTags

		ldaddr	r9,WipeOut
		mr	r11,r21
.NextChar:	lbz	r10,0(r11)
		addi	r11,11,1
		lbz	r0,0(r9)
		addi	r9,r9,1
		cmpw	r10,r0
		bne	.CorrectCreate
		cmpwi	r10,0
		bne	.NextChar				
				
		li	r4,0
		CALLOS	r31,FindTask			#wipeout patch
				
		b	.CorrectCreate	
		
#******************************************************

NewProc:	prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		
		lis	r30,WarpLibBase@ha
		lwz	r30,WarpLibBase@l(r30)		
		lwz	r31,libwarp_IExec(r30)
		
		lwz	r29,libwarp_IDOS(r30)
		CALLOS	r29,GetEntryData
		mr	r28,r3
		
		bl	.StartProc
				
		mr	r4,r28
		CALLOS	r31,FreeVec
		
		lwz	r28,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16
		
		epilog
		
#******************************************************
		
.StartProc:	prolog
		
		stwu	r2,-4(r13)
		stwu	r16,-4(r13)
		stwu	r17,-4(r13)
		stwu	r11,-4(r13)
		stwu	r12,-4(r13)
		stwu	r14,-4(r13)
		stwu	r15,-4(r13)
		stwu	r18,-4(r13)
		stwu	r19,-4(r13)
		stwu	r20,-4(r13)
		stwu	r21,-4(r13)
		stwu	r22,-4(r13)
		stwu	r23,-4(r13)
		stwu	r24,-4(r13)
		stwu	r25,-4(r13)
		stwu	r26,-4(r13)
		stwu	r27,-4(r13)
		stwu	r28,-4(r13)
		stwu	r29,-4(r13)
		stwu	r30,-4(r13)
		stwu	r31,-4(r13)
			
		mr	r16,r3
		mr	r3,r30	
					
		b	.SNewProc	
	
#******************************************************

.tagCODE:	lwz	r24,4(r26)
		b	.DoNextTag
		
.tagNAME:	lwz	r21,4(r26)
		b	.DoNextTag
		
.tagPRI:	mr.	r22,r22
		bne	.DoNextTag
		lwz	r23,4(r26)
		b	.DoNextTag
		
.tagSTACKSIZE:	lwz	r16,4(r26)
		lis	r0,1
		cmplw	r16,r0
		ble	.DoNextTag
		addi	r0,r16,15
		rlwinm	r16,r16,0,0,27
		b	.DoNextTag
		
.tagREGR2:	mr.	r25,r25
		bne	.DoNextTag
		lwz	r0,4(r26)
		stw	r0,0(r27)
		b	.DoNextTag
		
.tagREG:	subis	r9,r20,TASKATTR_CODE@h
		subi	r0,r9,TASKATTR_R2@l
		rlwinm	r9,r0,2,0,29
		lwz	r0,4(r26)
		stwx	r0,r27,r9
		b	.DoNextTag

.tagINHERITR2:	lwz	r25,4(r26)
		mr.	r25,r25
		beq	.DoNextTag
		stw	r2,0(r27)
		b	.DoNextTag
			
.tagNICE:	lwz	r0,4(r26)
		cmpwi	r0,0
		ble	.DoNextTag
		subi	r23,r23,1
		b	.DoNextTag
		
.tagMOTHERPRI:	lwz	r0,4(r26)
		li	r22,0
		cmpwi	r0,0
		beq	.DoNextTag
		mr	r4,r22
		CALLOS	r31,FindTask
		lwz	r22,4(r26)
		lbz	r0,LN_PRI(r3)
		extsb	r23,r0
		b	.DoNextTag

#********************************************************************************************

DeleteTaskPPC:
		prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r27,-4(r13)

		mr	r30,r3
	
		lhz	r29,lib_OpenCnt(r30)
		lwz	r31,libwarp_IExec(r30)
		subi	r29,r29,1
		sth	r29,lib_OpenCnt(r30)
		
		mr	r29,r4
		lwz	r4,libwarp_TaskList(r30)
		CALLOS	r31,GetHead
		mr.	r4,r3
		beq	.LEmpty
		
.ReTestList:	cmpw	r4,r29
		beq	.PseudoTask
		
		CALLOS	r31,GetSucc
		mr.	r4,r3
		beq	.LEmpty
		b	.ReTestList
		
.PseudoTask:	lwz	r29,TASKPPC_TASKPTR(r4)
		mr	r27,r4		
		CALLOS	r31,Remove
		
		mr	r4,r27
		CALLOS	r31,FreeVec
		
.LEmpty:	mr	r4,r29
		CALLOS	r31,DeleteTask				#Needs adjustment to Pseudo task

		lwz	r27,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16
		
		epilog

#********************************************************************************************

FindTaskPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		mr	r5,r4
		mr.	r28,r4
		lwz	r31,libwarp_IExec(r30)
		la	r4,libwarp_TaskList(r30)
		bne	.NoSelf
		
		mr	r4,r28
		CALLOS	r31,FindTask
		lwz	r5,LN_NAME(r3)
		mr	r29,r3
		la	r4,libwarp_TaskList(r30)
		
.NoSelf:	CALLOS	r31,FindName
		
		mr.	r28,r28
		bne	.NoSelf2

		mr. 	r3,r3
		bne	.NoSelf2
		
		loadreg	r5,MEMF_SHARED|MEMF_CLEAR
		li	r4,TASKPPC_MSGPORT+4
		CALLOS	r31,AllocVec
		
		lwz	r28,LN_NAME(r29)
		stw	r28,LN_NAME(r3)
		la	r28,pr_MsgPort(r29)
		stw	r28,TASKPPC_MSGPORT(r3)
		li	r28,NT_PROCESS
		stb	r28,LN_TYPE(r3)
		stw	r29,TASKPPC_TASKPTR(r3)
		mr	r28,r3
		
		li	r0,21
		mfctr	r5
		la	r29,8(r29)
		la	r3,8(r3)
		mtctr	r0
.CopyTask:	lwzu	r0,4(r29)
		stwu	r0,4(r3)
		bdnz	.CopyTask
		
		mtctr	r5
		mr	r5,r28
		la	r4,libwarp_TaskList(r30)
		CALLOS	r31,AddHead
		mr	r3,r28
		
.NoSelf2:	lwz	r27,0(r13)
		lwz	r28,4(r13)
		lwz	r29,8(r13)
		lwz	r30,12(r13)
		lwz	r31,16(r13)
		addi	r13,r13,20
		
		epilog

#********************************************************************************************

InitSemaphorePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,InitSemaphore
		
		li	r3,SSPPC_SUCCESS
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

FreeSemaphorePPC:					#Not needed
		blr

#********************************************************************************************

AddSemaphorePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,AddSemaphore
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

RemSemaphorePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,RemSemaphore
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

ObtainSemaphorePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,ObtainSemaphore
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

AttemptSemaphorePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,AttemptSemaphore
		
		cntlzw	r31,r3
		rlwinm	r31,r31,27,5,31
		subi	r3,r31,1

		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8

		epilog

#********************************************************************************************

ReleaseSemaphorePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,ReleaseSemaphore

		lwz	r27,0(r13)		
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

FindSemaphorePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3

		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,FindSemaphore
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

InsertPPC:	
		prolog
		
		lwz	r7,libwarp_IExec(r3)
		CALLOS	r7,Insert

		epilog

#********************************************************************************************

AddHeadPPC:
		prolog
		
		lwz	r7,libwarp_IExec(r3)
		CALLOS	r7,AddHead

		epilog

#********************************************************************************************

AddTailPPC:
		prolog
		
		lwz	r7,libwarp_IExec(r3)
		CALLOS	r7,AddTail

		epilog

#********************************************************************************************

RemovePPC:
		prolog
		
		lwz	r7,libwarp_IExec(r3)
		CALLOS	r7,Remove

		epilog

#********************************************************************************************

RemHeadPPC:
		prolog
		
		lwz	r7,libwarp_IExec(r3)
		CALLOS	r7,RemHead

		epilog

#********************************************************************************************

RemTailPPC:
		prolog
		
		lwz	r7,libwarp_IExec(r3)
		CALLOS	r7,RemTail

		epilog

#********************************************************************************************

EnqueuePPC:
		prolog
		
		lwz	r7,libwarp_IExec(r3)
		CALLOS	r7,Enqueue

		epilog

#********************************************************************************************

FindNamePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		
		CALLOS	r31,FindName
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

FindTagItemPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IUtility(r30)
		
		CALLOS	r31,FindTagItem
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

GetTagDataPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IUtility(r30)
		
		CALLOS	r31,GetTagData
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

NextTagItemPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IUtility(r30)
		
		CALLOS	r31,NextTagItem
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

AllocSignalPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		extsb	r4,r4
		lwz	r31,libwarp_IExec(r30)
		
		CALLOS	r31,AllocSignal
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

FreeSignalPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		extsb	r4,r4
		lwz	r31,libwarp_IExec(r30)
		
		CALLOS	r31,FreeSignal
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SetSignalPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3		
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,SetSignal
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SignalPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IExec(r30)
		lwz	r4,TASKPPC_TASKPTR(r4)
		
		CALLOS	r31,Signal
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

WaitPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)

		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,Wait
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SetTaskPriPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		extsb	r5,r5
		lwz	r4,TASKPPC_TASKPTR(r4)
		mr	r30,r3
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,SetTaskPri
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

Signal68K:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,Signal
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SetCache:					#Not implemented
		blr

#********************************************************************************************

SetExcHandler:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FSetExcHandler
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

RemExcHandler:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FRemExcHandler
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

Super:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,SuperState
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

User:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,UserState
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SetHardware:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FSetHardware
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

ModifyFPExc:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FModifyFPExc
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

WaitTime:
		mr.	r5,r5
		beq	WaitPPC
		
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r27,-4(r13)
		stwu	r26,-4(r13)
		stwu	r25,-4(r13)
		stwu	r24,-4(r13)
		stwu	r23,-4(r13)
		stwu	r22,-4(r13)
		
		mr	r23,r5
		mr	r24,r4
		mr	r28,r3
		li	r26,TAG_DONE		
		lwz	r31,libwarp_IExec(r28)
		
		li	r4,ASOT_PORT
		stw	r26,8(r1)
		CALLOS	r31,AllocSysObjectTags

		mr.	r27,r3
		beq	.CrashError
		
		li	r4,ASOT_IOREQUEST
		stw	r26,24(r1)
		loadreg	r5,ASOIOR_ReplyPort
		stw	r5,8(r1)
		stw	r27,12(r1)
		loadreg	r5,ASOIOR_Size
		stw	r5,16(r1)
		li	r5,40
		stw	r5,20(r1)
		CALLOS	r31,AllocSysObjectTags
		
		mr.	r30,r3
		beq	.CrashError
		
		ldaddr	r4,TimerDev
		li	r5,UNIT_MICROHZ
		mr	r6,r30
		li	r7,0
		CALLOS	r31,OpenDevice		
		
		mr.	r3,r3
		bne	.CrashError
		
		li	r0,TR_ADDREQUEST			
		lbz	r25,MP_SIGBIT(r27)
		sth	r0,io_Command(r30)
		li	r29,1
		slw	r29,r29,r25
		stw	r26,io_Actual+TV_SECS(r30)
		or	r29,r29,r24
		stw	r23,io_Actual+TV_MICRO(r30)
		
		mr	r4,r30
		
		CALLOS	r31,SendIO
		
		mr	r4,r29
		
		CALLOS	r31,Wait
		
		mr	r22,r3
		mr	r4,r30
		
		CALLOS	r31,CheckIO
		
		mr.	r3,r3
		bne	.TimesUp
		
		mr	r4,r30
		
		CALLOS	r31,AbortIO
		
.TimesUp:	mr	r4,r30
		
		CALLOS	r31,WaitIO
		
		mr	r4,r30

		CALLOS	r31,CloseDevice	
	
		li	r4,ASOT_IOREQUEST
		mr	r5,r30
		
		CALLOS	r31,FreeSysObject

		li	r4,ASOT_PORT
		mr	r5,r27

		CALLOS	r31,FreeSysObject

		li      r0,-2
		rotlw   r0,r0,r25
		and     r3,r22,r0

		lwz	r22,0(r13)
		lwz	r23,4(r13)
		lwz	r24,8(r13)
		lwz	r25,12(r13)
		lwz	r26,16(r13)
		lwz	r27,20(r13)
		lwz	r28,24(r13)
		lwz	r29,28(r13)
		lwz	r30,32(r13)
		lwz	r31,36(r13)
		addi	r13,r13,40

		epilog	

.CrashError:	illegal
		b	.CrashError
		
#********************************************************************************************

ChangeStack:					#ToBeImplemented!
		blr

#********************************************************************************************

LockTaskList:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FLockTaskList
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

UnLockTaskList:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FUnLockTaskList
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SetExcMMU:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FSetExcMMU
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

ClearExcMMU:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FClearExcMMU
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

ChangeMMU:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FChangeMMU
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

GetInfo:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r27,-4(r13)
		stwu	r26,-4(r13)
		stwu	r25,-4(r13)
		stwu	r24,-4(r13)
		stwu	r23,-4(r13)
		stwu	r22,-4(r13)
		stwu	r21,-4(r13)
		stwu	r20,-4(r13)
		
		mr	r30,r3
		stw	r4,72(r1)
		addi	r25,r1,72
		lwz	r31,libwarp_IExec(r30)
		lwz	r24,libwarp_IUtility(r30)
		
		loadreg	r29,GCIT_Model
		loadreg	r28,GCIT_FrontSideSpeed
		loadreg	r26,GCIT_ProcessorSpeed
		addi	r0,r1,40
		stw	r29,8(r1)
		stw	r0,12(r1)
		addi	r0,r1,48
		stw	r28,16(r1)
		stw	r0,20(r1)
		addi	r0,r1,56
		stw	r26,24(r1)
		stw	r0,28(r1)
		li	r0,TAG_DONE
		stw	r0,32(r1)
		CALLOS	r31,GetCPUInfoTags
		
		li	r4,0
		li	r5,0
		CALLOS	r31,CacheControl
		
		rlwinm	r0,r3,0,22,23
		clrlwi	r22,r3,30
		cmpwi	cr7,r0,512
		cmpwi	cr3,r0,768
		cmpwi	cr4,r22,3
		cmpwi	cr2,r22,1
		mfcr	r21
		rlwinm	r21,r21,28,0,3		
		ldaddr	r23,GetInfoTable
		
.NxtGITag:	mr	r4,r25
		CALLOS	r24,NextTagItem
		
		mr.	r29,r3
		beq	.EndGInfo
		
		lwz	r3,0(r29)
		loadreg	r20,PPCINFO_CPU
		sub	r3,r3,r20
		cmpwi	r3,7
		bgt	.NxtGITag	
		rlwinm	r0,r3,2,0,29
		lwzx	r20,r23,r0
		mtctr	r20
		bctr
	
.EndGInfo:	lwz	r20,0(r13)
		lwz	r21,4(r13)
		lwz	r22,8(r13)
		lwz	r23,12(r13)
		lwz	r24,16(r13)
		lwz	r25,20(r13)
		lwz	r26,24(r13)
		lwz	r27,28(r13)
		lwz	r28,32(r13)
		lwz	r29,36(r13)
		lwz	r30,40(r13)
		lwz	r31,44(r13)
		addi	r13,r13,48
	
		epilog
		
.tagCPU:	lwz	r0,40(r1)
		cmpwi	r0,CPUTYPE_603E
		beq	.CPU603E
		cmpwi	r0,CPUTYPE_604E
		bne	.NxtGITag
		
		lis	r0,CPUF_604E@h
		stw	r0,4(r29)
		b	.NxtGITag
		
.CPU603E:	li	r0,CPUF_603E
		stw	r0,4(r29)
		b	.NxtGITag
					
.tagPVR:	CALLOS	r31,SuperState
		mfpvr	r28
		mr.	r4,r3
		beq	.WasSuper
		CALLOS	r31,UserState
		
.WasSuper:	stw	r28,4(r29)
		b	.NxtGITag
				
.tagICACHE:	nop
		b	.NxtGITag
		
.tagDCACHE:	nop
		b	.NxtGITag

.tagPAGETABLE:	nop
		b	.NxtGITag

.tagTABLESIZE:	nop
		b	.NxtGITag
		
.tagBUSCLOCK:	lwz	r0,52(r1)
		stw	r0,4(r29)
		b	.NxtGITag
		
.tagCPUCLOCK:	lwz	r0,60(r1)
		stw	r0,4(r29)
		b	.NxtGITag			

#********************************************************************************************

CreateMsgPortPPC:

		prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3

		li      r29,100
		li      r4,ASOT_PORT
		loadreg	r0,ASOPORT_Size
		lwz	r31,libwarp_IExec(r30)
		stw     r0,8(r1)
		li      r0,TAG_DONE
		stw     r0,16(r1)
		stw     r29,12(r1)
		CALLOS	r31,AllocSysObjectTags

		lwz	r27,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16

		epilog

#********************************************************************************************

DeleteMsgPortPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		mr      r5,r4
		li      r4,ASOT_PORT
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,FreeSysObject

		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12

		epilog

#********************************************************************************************

AddPortPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,AddPort
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

RemPortPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,RemPort
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

FindPortPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,FindPort
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

WaitPortPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,WaitPort
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

PutMsgPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,PutMsg
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

GetMsgPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,GetMsg
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

ReplyMsgPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,ReplyMsg
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

FreeAllMem:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r26,-4(r13)

		mr	r30,r3
		lwz	r31,libwarp_IExec(r30)
		la	r4,libwarp_MemSem(r30)
		CALLOS	r31,ObtainSemaphore
		
		li	r4,0
		CALLOS	r31,FindTask
		
		mr	r26,r3
		lwz	r29,libwarp_MemList(r30)
.NxtInList:	lwz	r28,LN_SUCC(r29)
		mr.	r28,r28
		beq	.EndOfList
		lwz	r0,8(r29)
		cmpw	r26,r0
		beq	.FndTask
.GetNxtList:	mr	r29,r28
		b	.NxtInList
		
.FndTask:	mr	r4,r29
		CALLOS	r31,Remove
		
		mr	r4,r29
		CALLOS	r31,FreeVec
		
		b	.GetNxtList		

.EndOfList:	la	r4,libwarp_MemSem(r30)
		CALLOS	r31,ReleaseSemaphore
		
		lwz	r26,0(r13)
		lwz	r28,4(r13)
		lwz	r29,8(r13)
		lwz	r30,12(r13)
		lwz	r31,16(r13)
		addi	r13,r13,20
		
		epilog

#********************************************************************************************

CopyMemPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IUtility(r30)
		CALLOS	r31,MoveMem
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

AllocXMsgPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3		
		mr      r29,r5
		
		loadreg	r5,MEMF_SHARED|MEMF_CLEAR
		addi    r28,r4,MN_SIZE
		lwz	r31,libwarp_IExec(r30)
		mr      r4,r28
		
		CALLOS	r31,AllocVec
		
		mr.     r3,r3
		beq-    .NoMsgMem
		sth     r28,MN_LENGTH(r3)
		stw     r29,MN_REPLYPORT(r3)
		
.NoMsgMem:	lwz	r27,0(r13)
		lwz	r28,4(r13)
		lwz	r29,8(r13)
		lwz	r30,12(r13)
		lwz	r31,16(r13)
		addi	r13,r13,20

		epilog

#********************************************************************************************

FreeXMsgPPC:
		prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)

		mr	r30,r3		
		
		lwz	r31,libwarp_IExec(r30)		
		CALLOS	r31,FreeVec

		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12

		epilog

#********************************************************************************************

PutXMsgPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		li	r0,NT_XMSGPPC
		stb	r0,LN_TYPE(r5)		
		CALLOS	r31,PutMsg				#rewrite this function to preserve correct node type?
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

GetSysTimePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		
		mr	r31,r3
		lwz	r30,libwarp_ITimer(r3)
		mr	r29,r4
		
		CALLOS	r30,GetSysTime
		
		mr	r4,r29
		la	r5,libwarp_StartTimeVal(r31)
		mr	r31,r5
		
		CALLOS	r30,SubTime
		
		lwz	r29,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog
		
#********************************************************************************************

AddTimePPC:
		prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_ITimer(r30)		
		CALLOS	r31,AddTime
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog		

#********************************************************************************************

SubTimePPC:
		prolog

		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_ITimer(r30)		
		CALLOS	r31,SubTime
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

CmpTimePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_ITimer(r30)
		CALLOS	r31,CmpTime
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SetReplyPortPPC:
		lwz	r3,MN_REPLYPORT(r4)
		stw	r5,MN_REPLYPORT(r4)
		blr

#********************************************************************************************

SnoopTask:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FSnoopTask
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

EndSnoopTask:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FEndSnoopTask
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

GetHALInfo:						#needs implementation!
		illegal
		li	r3,84
		blr

#********************************************************************************************

SetScheduling:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FSetScheduling
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

FindTaskByID:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FFindTaskByID
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SetNiceValue:
		li	r3,0
		blr

#********************************************************************************************

TrySemaphorePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,AttemptSemaphore
		
		cntlzw	r30,r3
		rlwinm	r30,r30,27,5,31
		subi	r3,r30,1
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

AllocPrivateMem:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FAllocPrivateMem
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

FreePrivateMem:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FFreePrivateMem
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

ResetPPC:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FResetPPC
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

NewListPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,NewList
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

SetExceptPPC:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FSetExceptPPC
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

ObtainSemaphoreSharedPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,ObtainSemaphoreShared
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

AttemptSemaphoreSharedPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,AttemptSemaphoreShared
		
		cntlzw	r31,r3
		rlwinm	r31,r31,27,5,31
		subi	r3,r31,1
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

ProcurePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,Procure
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

VacatePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,Vacate
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

CauseInterrupt:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FCauseInterrupt
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

CreatePoolPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		loadreg	r0,MEMF_CLEAR|MEMF_CHIP|MEMF_REVERSE
		and	r4,r4,r0
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,CreatePool
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

DeletePoolPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3		
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,DeletePool
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

AllocPooledPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)

		mr	r30,r3		
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,AllocPooled
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

FreePooledPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,FreePooled
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

RawDoFmtPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IExec(r30)
		mr	r0,r5
		cmpwi	r6,1
		beq	.RawExit
		cmpwi	r6,0
		beq	.RawProc1
		
		stw	r6,8(r1)
		stw	r7,12(r1)
		ldaddr	r6,.RawProc2
		addi	r7,r1,8
		
.RawProc1:	CALLOS	r31,RawDoFmt
		
		mr	r0,r3
.RawExit:	mr	r3,r0
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog
		
.RawProc2:	prolog
		
		mr	r9,r4
		mr	r4,r3
		lwz	r3,4(r9)
		lwz	r9,0(r9)
		mtctr	r9
		bctrl

		epilog

#********************************************************************************************

PutPublicMsgPPC:
   		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		
		mr      r29,r5
		mr	r30,r3
		
		lwz	r31,libwarp_IExec(r30)
		CALLOS	r31,FindPort
    
		mr.     r4,r3
		beq	.NoPortFound
    
		mr      r5,r29
		CALLOS	r31,PutMsg
		
		li	r3,-1

.NoPortFound:	lwz	r29,0(r13)
		lwz	r30,4(r13)
		lwz	r31,8(r13)
		addi	r13,r13,12
		
		epilog

#********************************************************************************************

AddUniquePortPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		
		mr	r30,r3
		mr	r29,r4
		
		lwz	r31,libwarp_IExec(r30)
		la	r4,libwarp_PortSem(r30)		
		CALLOS	r31,ObtainSemaphore
		
		lwz	r4,LN_NAME(r29)
		CALLOS	r31,FindPort
		
		mr.	r28,r3
		li	r28,UNIPORT_NOTUNIQUE
		bne	.ExitUPort
		
		mr	r4,r29
		CALLOS	r31,AddPort
		
		li	r28,UNIPORT_SUCCESS
		
.ExitUPort:	la	r4,libwarp_PortSem(r30)		
		CALLOS	r31,ReleaseSemaphore
		
		mr	r3,r28
		
		lwz	r28,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16
		
		epilog		

#********************************************************************************************

AddUniqueSemaphorePPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		
		mr	r30,r3
		mr	r29,r4
		
		lwz	r31,libwarp_IExec(r30)
		la	r4,libwarp_SemSem(r30)		
		CALLOS	r31,ObtainSemaphore
		
		lwz	r4,LN_NAME(r29)
		CALLOS	r31,FindSemaphore
		
		mr.	r28,r3
		li	r28,UNISEM_NOTUNIQUE
		bne	.ExitUSem
		
		mr	r4,r29
		CALLOS	r31,AddSemaphore
		
		li	r28,UNISEM_SUCCESS
		
.ExitUSem:	la	r4,libwarp_SemSem(r30)		
		CALLOS	r31,ReleaseSemaphore
		
		mr	r3,r28
		
		lwz	r28,0(r13)
		lwz	r29,4(r13)
		lwz	r30,8(r13)
		lwz	r31,12(r13)
		addi	r13,r13,16
		
		epilog		

#********************************************************************************************

IsExceptionMode:
		prolog
		
		stwu	r30,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r30,r3
		ldaddr	r27,FIsExceptionMode
		bl	.UnSupported		
		li	r3,0
		
		lwz	r27,0(r13)
		lwz	r30,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************
#********************************************************************************************

		.rodata

#********************************************************************************************

LibName:		
.byte	"powerpc.library",0
ExpLib:
.byte	"expansion.library",0
TimerDev:
.byte	"timer.device",0
DosLib:
.byte	"dos.library",0
UtilLib:
.byte	"utility.library",0
MainName:
.byte	"main",0
WipeOut:
.byte	"wo2097_mixer",0

IDString:	
.byte	"$VER: powerpc.library 18.0 (01-Jun-16)",0

UnSupportedString:	.byte	"Unsupported function! Process: %s Function: %s",10,0

FCausePPCInterrupt:		.byte	"FCausePPCInterrupt",0
FRun68KLowLevel:		.byte	"Run68KLowLevel",0
FSetExcHandler:			.byte	"SetExcHandler",0
FRemExcHandler:			.byte	"RemExcHandler",0
FSetHardware:			.byte	"SetHardware",0
FModifyFPExc:			.byte	"ModifyFPExc",0
FLockTaskList:			.byte	"LockTaskList",0
FUnLockTaskList:		.byte	"UnlockTaskList",0
FSetExcMMU:			.byte	"SetExcMMU",0
FClearExcMMU:			.byte	"ClearExcMMU",0
FChangeMMU:			.byte	"ChangeMMU",0
FSnoopTask:			.byte	"SnoopTask",0
FEndSnoopTask:			.byte	"EndSnoopTask",0
FSetScheduling:			.byte	"SetScheduling",0
FFindTaskByID:			.byte	"FindTaskByID",0
FAllocPrivateMem:		.byte	"AllocPrivateMem",0
FFreePrivateMem:		.byte	"FreePrivateMem",0
FResetPPC:			.byte	"ResetPPC",0
FSetExceptPPC:			.byte	"SetExceptPPC",0
FCauseInterrupt:		.byte	"CauseInterrupt",0
FIsExceptionMode:		.byte	"IsExceptionMode",0

.align	2

#********************************************************************************************

JumpTable:
.long	.tagCODE,.DoNextTag,.tagNAME,.tagPRI,.tagSTACKSIZE
.long	.tagREGR2,.tagREG,.tagREG,.tagREG,.tagREG,.tagREG,.tagREG,.tagREG,.tagREG
.long	.DoNextTag,.tagMOTHERPRI,.DoNextTag,.DoNextTag,.tagNICE,.tagINHERITR2,.DoNextTag
.long	.DoNextTag

GetInfoTable:
.long	.tagCPU,.tagPVR,.tagICACHE,.tagDCACHE,.tagPAGETABLE,.tagTABLESIZE
.long	.tagBUSCLOCK,.tagCPUCLOCK

#********************************************************************************************

ROMTAG:
.word	RTC_MATCHWORD
.ualong	ROMTAG
.ualong	ROMTAG+1								#ENDSKIP
.byte	RTF_AUTOINIT|RTF_NATIVE
.byte	18									#RT_VERSION
.byte	NT_LIBRARY								#RT_TYPE
.byte	0									#RT_PRI
.ualong	LibName
.ualong	IDString
.ualong	CreateLibTags

.align	2

#********************************************************************************************

CreateLibTags:
.long	CLT_DataSize,libwarp_PosSize,CLT_Interfaces,INTERFACETABLE,CLT_InitFunc,INITFUNC,CLT_Vector68K,VECTOR68K,TAG_DONE,0

INTERFACETABLE:
.long	MYINTERFACE,0

MYINTERFACE:
.long	MIT_Name,INTNAME,MIT_VectorTable,VECTORPPC,MIT_Version,1,TAG_DONE,0

INTNAME:
.byte	"__library",0

.align	2

VECTORPPC:
.long	IObtain
.long	IRelease
.long	0,0
.long	IOpen
.long	IClose
.long	IExpunge
.long	0,-1

VECTOR68K:
.long	Open					#68K
.long	Close
.long	Expunge
.long	Reserved
.long	RunPPC
.long	WaitForPPC
.long	GetCPU
.long	PowerDebugMode
.long	AllocVec32
.long	FreeVec32
.long	SPrintF68K
.long	AllocXMsg
.long	FreeXMsg
.long	PutXMsg
.long	GetPPCState
.long	SetCache68K
.long	CreatePPCTask
.long	CausePPCInterrupt

.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved
.long	Reserved				#49 68K Functions

.long	Run68K					#PPC (legacy vector table)
.long	WaitFor68K
.long	SPrintF
.long	Run68KLowLevel
.long	AllocVecPPC
.long	FreeVecPPC
.long	CreateTaskPPC
.long	DeleteTaskPPC
.long	FindTaskPPC
.long	InitSemaphorePPC
.long	FreeSemaphorePPC
.long	AddSemaphorePPC
.long	RemSemaphorePPC
.long	ObtainSemaphorePPC
.long	AttemptSemaphorePPC
.long	ReleaseSemaphorePPC
.long	FindSemaphorePPC
.long	InsertPPC
.long	AddHeadPPC
.long	AddTailPPC
.long	RemovePPC
.long	RemHeadPPC
.long	RemTailPPC
.long	EnqueuePPC
.long	FindNamePPC
.long	FindTagItemPPC
.long	GetTagDataPPC
.long	NextTagItemPPC
.long	AllocSignalPPC
.long	FreeSignalPPC
.long	SetSignalPPC
.long	SignalPPC
.long	WaitPPC
.long	SetTaskPriPPC
.long	Signal68K
.long	SetCache
.long	SetExcHandler
.long	RemExcHandler
.long	Super
.long	User
.long	SetHardware
.long	ModifyFPExc
.long	WaitTime
.long	ChangeStack
.long	LockTaskList
.long	UnLockTaskList
.long	SetExcMMU
.long	ClearExcMMU
.long	ChangeMMU
.long	GetInfo
.long	CreateMsgPortPPC
.long	DeleteMsgPortPPC
.long	AddPortPPC
.long	RemPortPPC
.long	FindPortPPC
.long	WaitPortPPC
.long	PutMsgPPC
.long	GetMsgPPC
.long	ReplyMsgPPC
.long	FreeAllMem
.long	CopyMemPPC
.long	AllocXMsgPPC
.long	FreeXMsgPPC
.long	PutXMsgPPC
.long	GetSysTimePPC
.long	AddTimePPC
.long	SubTimePPC
.long	CmpTimePPC
.long	SetReplyPortPPC
.long	SnoopTask
.long	EndSnoopTask
.long	GetHALInfo
.long	SetScheduling
.long	FindTaskByID
.long	SetNiceValue
.long	TrySemaphorePPC
.long	AllocPrivateMem
.long	FreePrivateMem
.long	ResetPPC
.long	NewListPPC
.long	SetExceptPPC
.long	ObtainSemaphoreSharedPPC
.long	AttemptSemaphoreSharedPPC
.long	ProcurePPC
.long	VacatePPC
.long	CauseInterrupt
.long	CreatePoolPPC
.long	DeletePoolPPC
.long	AllocPooledPPC
.long	FreePooledPPC
.long	RawDoFmtPPC
.long	PutPublicMsgPPC
.long	AddUniquePortPPC
.long	AddUniqueSemaphorePPC
.long	IsExceptionMode
.long	-1

#********************************************************************************************

Open:				jmp Open68K
Close:				jmp Close68K
Expunge:			jmp Expunge68K
Reserved:			jmp Reserved68K
RunPPC:				jmp RunPPC68K
WaitForPPC:			jmp WaitForPPC68K
GetCPU:				jmp GetCPU68K
PowerDebugMode:			jmp PowerDebugMode68K
AllocVec32:			jmp AllocVec3268K
FreeVec32:			jmp FreeVec3268K
SPrintF68K:			jmp SPrintF68K68K
AllocXMsg:			jmp AllocXMsg68K
FreeXMsg:			jmp FreeXMsg68K
PutXMsg:			jmp PutXMsg68K
GetPPCState:			jmp GetPPCState68K
SetCache68K:			jmp SetCache68K68K
CreatePPCTask:			jmp CreatePPCTask68K
CausePPCInterrupt:		jmp CausePPCInterrupt68K

#********************************************************************************************
#********************************************************************************************

		.sbss
		.align 4
AlignSpot:	.long 0,0
WarpLibBase:	.long 0

#********************************************************************************************
