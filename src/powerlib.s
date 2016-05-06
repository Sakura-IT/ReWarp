
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
		sth	r0,lib_Revision(r3)
		stw	r9,lib_IdString(r3)
		stw	r5,libwarp_IExec(r3)
		mr	r31,r3
		mr	r29,r5
		
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
		li	r5,0
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
		prolog
		lis	r0,TRAPNUM_INST_SEGMENT_VIOLATION
		cmpw	r5,r0
		beq	.ItsAnISI
		li	r3,0
.ExcExit:	epilog		
		
.ItsAnISI:	stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r26,-4(r13)
		stwu	r25,-4(r13)
		lwz	r31,ExceptionContext_ip(r3)
		li	r3,0
		mfctr	r30
		lis	r29,WarpLibBase@ha
		lwz	r29,WarpLibBase@l(r29)
		lwz	r29,libwarp_MachineFlag(r29)
		cmpwi	r29,MACHF_PPC500LIKE
		beq	.ISIPPC500
		rlwinm.	r31,r31,0,0,19
		beq	.ExcDone
		li	r29,64
		mtctr	r29
		li	r29,0
		
.NextTBL:	addi	r29,r29,1
		bdz	.ExcDone
		
		tlbrehi	r28,r29
		tlbre	r26,r29,2
		andi.	r25,r28,TLB_VALID
		beq	.NextTBL
		rlwinm	r25,r28,0,0,TLB_EPN
		cmpw	r25,r31
		bne	.NextTBL
		ori	r26,r26,TLB_UX|TLB_SX
		tlbwe	r26,r29,2
		li	r3,1
.ExcDone:	mtctr	r30
		lwz	r25,0(r13)
		lwz	r26,4(r13)
		lwz	r28,8(r13)
		lwz	r29,12(r13)
		lwz	r30,16(r13)
		lwz	r31,20(r13)
		addi	r13,r13,24		
		b	.ExcExit
		
.ISIPPC500:	mfmsr	r25
		rlwinm	r26,r25,27,31,31			#Get MSR[IS]
		mfspr	r25,PID0
		slwi	r25,r25,16
		or	r25,r25,r26
		mtspr	MAS6,r25
		isync
		tlbsx	r0,r0,r31
		mfspr	r25,MAS1
		andis.	r25,r25,MAS1_VALID@h
		bne	.GotTBL
		mfspr	r25,PID1
		slwi	r25,r25,16
		or	r25,r25,r26
		mtspr	MAS6,r25
		isync
		tlbsx	r0,r0,r31
		mfspr	r25,MAS1
		andis.	r25,r25,MAS1_VALID@h
		bne	.GotTBL
		mfspr	r25,PID2
		slwi	r25,r25,16
		or	r25,r25,r26
		mtspr	MAS6,r25
		isync
		tlbsx	r0,r0,r31				#Should be tlbsx r0,r31 in BookE
		mfspr	r25,MAS1
		andis.	r25,r25,MAS1_VALID@h
		beq	.ExcDone
.GotTBL:	mfspr	r25,MAS3
		ori	r25,r25,MAS3_UX|MAS3_SX
		mtspr	MAS3,r25
		isync
		tlbwe	r0,r0,0					#Should be tlbwe in BookE
		li	r3,1
		b	.ExcDone
		
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
		lhz	r9,lib_OpenCnt(r31)
		addi	r9,r9,1
		sth	r9,lib_OpenCnt(r31)
		cmpwi	r9,1
		bne	.GoExitOpen

		lwz	r4,libwarp_MachineFlag(r31)
		mr.	r4,r4
		li	r28,1
		lwz	r30,libwarp_IExec(r31)
		beq	.ItsPPC600
		
		lis     r4,TRAPNUM_INST_SEGMENT_VIOLATION
		ldaddr	r5,ExceptionHandler
		lis     r6,TRAPNUM_INST_SEGMENT_VIOLATION
		CALLOS	r30,SetTaskTrap		
				
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
		lhz	r9,lib_OpenCnt(r31)
		subi	r9,r9,1
		sth	r9,lib_OpenCnt(r31)
		cmpwi	r9,0
		li	r3,0
		bne	.GoExitClose
		
		lwz	r4,libwarp_MachineFlag(r31)
		mr.	r4,r4
		li	r28,0
		lwz	r30,libwarp_IExec(r31)
		beq	.ItsPPC600
		
		lis	r4,TRAPNUM_INST_SEGMENT_VIOLATION
		li	r5,0
		li	r6,0
		CALLOS	r30,SetTaskTrap
		
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
		lwz	r17,PP_FLAGS(r16)
		mr.	r17,17
		bne	.NotStandard
	
		lwz	r3,REG68K_A6(r3)
		lwz	r31,libwarp_IExec(r3)
		mr	r26,r3
		
		lwz	r27,libwarp_MachineFlag(r26)
		mr.	r27,r27
		bne	.NoFlushNeeded
		
		lwz	r27,libwarp_CachedTask(r26)
		li	r4,0
		CALLOS	r31,FindTask
		cmpw	r3,r27
		stw	r3,libwarp_CachedTask(r26)
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
		
		lfd	f1,PP_FREGS+0*8(r16)			#Perform FPU test here
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
		blrl
		
		stw	r3,PP_REGS+0*4(r16)
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
				
		li	r3,PPERR_SUCCESS
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
		illegal
		li	r3,1
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
		li	r3,0
		blr

#********************************************************************************************

AllocVec3268K:
		illegal
		li	r3,3
		blr

#********************************************************************************************

FreeVec3268K:
		illegal
		li	r3,4
		blr

#********************************************************************************************

SPrintF68K68K:
		illegal
		li	r3,5
		blr

#********************************************************************************************

AllocXMsg68K:
		illegal
		li	r3,6
		blr

#********************************************************************************************

FreeXMsg68K:
		illegal
		li	r3,7
		blr

#********************************************************************************************

PutXMsg68K:
		illegal
		li	r3,8
		blr

#********************************************************************************************

GetPPCState68K:
		illegal
		li	r3,9
		blr

#********************************************************************************************

SetCache68K68K:
		illegal
		li	r3,10
		blr

#********************************************************************************************

CreatePPCTask68K:
		illegal
		li	r3,11
		blr

#********************************************************************************************

CausePPCInterrupt68K:
		li	r3,12
		blr

#********************************************************************************************
#********************************************************************************************

Run68K:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		stwu	r29,-4(r13)
		stwu	r28,-4(r13)
		stwu	r27,-4(r13)
		
		mr	r31,r4
		mr	r30,r3
		lwz	r29,libwarp_IExec(r30)
		lwz	r27,PP_FLAGS(r31)
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

		li	r3,0
		b	.RunExit
		
.RunError68:	li	r3,3
				
.RunExit:	lwz	r27,0(r13)
		lwz	r28,4(r13)
		lwz	r29,8(r13)
		lwz	r30,12(r13)
		lwz	r31,16(r13)
		addi	r13,r13,20

		epilog

#********************************************************************************************

WaitFor68K:
		illegal
		li	r3,14
		blr

#********************************************************************************************

SPrintF:
		illegal
		li	r3,15
		blr

#********************************************************************************************

Run68KLowLevel:
		illegal
		li	r3,16
		blr

#********************************************************************************************

AllocVecPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IExec(r3)
		loadreg	r0,MEMF_CLEAR|MEMF_CHIP|MEMF_REVERSE
		and	r5,r5,r0
		
		CALLOS	r31,AllocVec
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

FreeVecPPC:
		prolog
		
		stwu	r31,-4(r13)
		stwu	r30,-4(r13)
		
		mr	r30,r3
		lwz	r31,libwarp_IExec(r3)
		
		CALLOS	r31,FreeVec
		
		lwz	r30,0(r13)
		lwz	r31,4(r13)
		addi	r13,r13,8
		
		epilog

#********************************************************************************************

CreateTaskPPC:
		illegal
		li	r3,19
		blr

#********************************************************************************************

DeleteTaskPPC:
		illegal
		li	r3,20
		blr

#********************************************************************************************

FindTaskPPC:
		illegal
		li	r3,21
		blr

#********************************************************************************************

InitSemaphorePPC:
		illegal
		li	r3,22
		blr

#********************************************************************************************

FreeSemaphorePPC:
		illegal
		li	r3,23
		blr

#********************************************************************************************

AddSemaphorePPC:
		illegal
		li	r3,24
		blr

#********************************************************************************************

RemSemaphorePPC:
		illegal
		li	r3,25
		blr

#********************************************************************************************

ObtainSemaphorePPC:
		illegal
		li	r3,26
		blr

#********************************************************************************************

AttemptSemaphorePPC:
		illegal
		li	r3,27
		blr

#********************************************************************************************

ReleaseSemaphorePPC:
		illegal
		li	r3,28
		blr

#********************************************************************************************

FindSemaphorePPC:
		illegal
		li	r3,29
		blr

#********************************************************************************************

InsertPPC:
		illegal
		li	r3,30
		blr

#********************************************************************************************

AddHeadPPC:
		illegal
		li	r3,31
		blr

#********************************************************************************************

AddTailPPC:
		illegal
		li	r3,32
		blr

#********************************************************************************************

RemovePPC:
		illegal
		li	r3,33
		blr

#********************************************************************************************

RemHeadPPC:
		illegal
		li	r3,34
		blr

#********************************************************************************************

RemTailPPC:
		illegal
		li	r3,35
		blr

#********************************************************************************************

EnqueuePPC:
		illegal
		li	r3,36
		blr

#********************************************************************************************

FindNamePPC:
		illegal
		li	r3,37
		blr

#********************************************************************************************

FindTagItemPPC:
		illegal
		li	r3,38
		blr

#********************************************************************************************

GetTagDataPPC:
		illegal
		li	r3,39
		blr

#********************************************************************************************

NextTagItemPPC:
		illegal
		li	r3,40
		blr

#********************************************************************************************

AllocSignalPPC:
		illegal
		li	r3,41
		blr

#********************************************************************************************

FreeSignalPPC:
		illegal
		li	r3,42
		blr

#********************************************************************************************

SetSignalPPC:
		illegal
		li	r3,43
		blr

#********************************************************************************************

SignalPPC:
		illegal
		li	r3,44
		blr

#********************************************************************************************

WaitPPC:
		illegal
		li	r3,45
		blr

#********************************************************************************************

SetTaskPriPPC:
		illegal
		li	r3,46
		blr

#********************************************************************************************

Signal68K:
		illegal
		li	r3,47
		blr

#********************************************************************************************

SetCache:
		illegal
		li	r3,48
		blr

#********************************************************************************************

SetExcHandler:
		illegal
		li	r3,49
		blr

#********************************************************************************************

RemExcHandler:
		illegal
		li	r3,50
		blr

#********************************************************************************************

Super:
		illegal
		li	r3,51
		blr

#********************************************************************************************

User:
		illegal
		li	r3,52
		blr

#********************************************************************************************

SetHardware:
		illegal
		li	r3,53
		blr

#********************************************************************************************

ModifyFPExc:
		illegal
		li	r3,54
		blr

#********************************************************************************************

WaitTime:
		illegal
		li	r3,55
		blr

#********************************************************************************************

ChangeStack:
		illegal
		li	r3,56
		blr

#********************************************************************************************

LockTaskList:
		illegal
		li	r3,57
		blr

#********************************************************************************************

UnLockTaskList:
		illegal
		li	r3,58
		blr

#********************************************************************************************

SetExcMMU:
		illegal
		li	r3,59
		blr

#********************************************************************************************

ClearExcMMU:
		illegal
		li	r3,60
		blr

#********************************************************************************************

ChangeMMU:
		illegal
		li	r3,61
		blr

#********************************************************************************************

GetInfo:	
		li	r3,0
		blr
		illegal
		li	r3,62
		blr

#********************************************************************************************

CreateMsgPortPPC:
		illegal
		li	r3,63
		blr

#********************************************************************************************

DeleteMsgPortPPC:
		illegal
		li	r3,64
		blr

#********************************************************************************************

AddPortPPC:
		illegal
		li	r3,65
		blr

#********************************************************************************************

RemPortPPC:
		illegal
		li	r3,66
		blr

#********************************************************************************************

FindPortPPC:
		illegal
		li	r3,67
		blr

#********************************************************************************************

WaitPortPPC:
		illegal
		li	r3,68
		blr

#********************************************************************************************

PutMsgPPC:
		illegal
		li	r3,69
		blr

#********************************************************************************************

GetMsgPPC:
		illegal
		li	r3,70
		blr

#********************************************************************************************

ReplyMsgPPC:
		illegal
		li	r3,71
		blr

#********************************************************************************************

FreeAllMem:
		illegal
		li	r3,72
		blr

#********************************************************************************************

CopyMemPPC:
		illegal
		li	r3,73
		blr

#********************************************************************************************

AllocXMsgPPC:
		illegal
		li	r3,74
		blr

#********************************************************************************************

FreeXMsgPPC:
		illegal
		li	r3,75
		blr

#********************************************************************************************

PutXMsgPPC:
		illegal
		li	r3,76
		blr

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
		illegal
		li	r3,78
		blr

#********************************************************************************************

SubTimePPC:
		prolog
		
		lwz	r9,libwarp_ITimer(r3)
		
		CALLOS	r9,SubTime
		
		epilog

#********************************************************************************************

CmpTimePPC:
		illegal
		li	r3,80
		blr

#********************************************************************************************

SetReplyPortPPC:
		illegal
		li	r3,81
		blr

#********************************************************************************************

SnoopTask:
		illegal
		li	r3,82
		blr

#********************************************************************************************

EndSnoopTask:
		illegal
		li	r3,83
		blr

#********************************************************************************************

GetHALInfo:
		illegal
		li	r3,84
		blr

#********************************************************************************************

SetScheduling:
		illegal
		li	r3,85
		blr

#********************************************************************************************

FindTaskByID:
		illegal
		li	r3,86
		blr

#********************************************************************************************

SetNiceValue:
		illegal
		li	r3,87
		blr

#********************************************************************************************

TrySemaphorePPC:
		illegal
		li	r3,88
		blr

#********************************************************************************************

AllocPrivateMem:
		illegal
		li	r3,89
		blr

#********************************************************************************************

FreePrivateMem:
		illegal
		li	r3,90
		blr

#********************************************************************************************

ResetPPC:
		illegal
		li	r3,91
		blr

#********************************************************************************************

NewListPPC:
		illegal
		li	r3,92
		blr

#********************************************************************************************

SetExceptPPC:
		illegal
		li	r3,93
		blr

#********************************************************************************************

ObtainSemaphoreSharedPPC:
		illegal
		li	r3,94
		blr

#********************************************************************************************

AttemptSemaphoreSharedPPC:
		illegal
		li	r3,95
		blr

#********************************************************************************************

ProcurePPC:
		illegal
		li	r3,96
		blr

#********************************************************************************************

VacatePPC:
		illegal
		li	r3,97
		blr

#********************************************************************************************

CauseInterrupt:
		illegal
		li	r3,98
		blr

#********************************************************************************************

CreatePoolPPC:
		illegal
		li	r3,99
		blr

#********************************************************************************************

DeletePoolPPC:
		illegal
		li	r3,100
		blr

#********************************************************************************************

AllocPooledPPC:
		illegal
		li	r3,101
		blr

#********************************************************************************************

FreePooledPPC:
		illegal
		li	r3,102
		blr

#********************************************************************************************

RawDoFmtPPC:
		illegal
		li	r3,103
		blr

#********************************************************************************************

PutPublicMsgPPC:
		illegal
		li	r3,104
		blr

#********************************************************************************************

AddUniquePortPPC:
		illegal
		li	r3,105
		blr

#********************************************************************************************

AddUniqueSemaphorePPC:
		illegal
		li	r3,106
		blr

#********************************************************************************************

IsExceptionMode:
		illegal
		li	r3,107
		blr

#********************************************************************************************

CreateMsgFramePPC:
		illegal
		li	r3,108
		blr

#********************************************************************************************

SendMsgFramePPC:
		illegal
		li	r3,109
		blr

#********************************************************************************************

FreeMsgFramePPC:
		illegal
		li	r3,110
		blr

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
MainName:
.byte	"main",0

IDString:	
.byte	"$VER: powerpc.library 18.0 (01-Jun-16)",0

.align	2

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
.long	CreateMsgFramePPC
.long	SendMsgFramePPC
.long	FreeMsgFramePPC
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

WarpLibBase:
.long		0

#********************************************************************************************
