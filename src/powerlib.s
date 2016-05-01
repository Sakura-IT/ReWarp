
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
		ldaddr	r4,ExpLib
		li	r5,52
		CALLOS	r29,OpenLibrary
		
		mr.	r28,r3
		beq	.ErrorExp
		ldaddr	r27,MainName
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
		ble	.ClassicSetup
		cmpwi	r14,MACHINETYPE_SAM440
		beq	.EBookSetup
		cmpwi	r14,MACHINETYPE_PEGASOSII
		beq	.ClassicSetup
		cmpwi	r14,MACHINETYPE_SAM460
		ble	.EBookSetup
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

.ClassicSetup:	
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

.EBookSetup:	
		li	r14,MACHF_PPC400LIKE
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
		lwz	r17,PP_OFFSET(r16)
		mr.	r17,r17
		bne	.NotStandard		
		lwz	r3,REG68K_A6(r3)

		lwz	r31,libwarp_IExec(r3)
		li	r4,0
		li	r5,-1
		li	r6,CACRF_ClearI
		
		CALLOS	r31,CacheClearE
		
		lwz	r3,PP_REGS+0*4(r16)
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
		mtlr	r17
		stw	r2,20(r1)
		blrl		
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

		li	r3,0
		blr

#********************************************************************************************

GetCPU68K:

		li	r3,0
		blr

#********************************************************************************************

PowerDebugMode68K:

		li	r3,0
		blr

#********************************************************************************************

AllocVec3268K:

		li	r3,0
		blr

#********************************************************************************************

FreeVec3268K:

		li	r3,0
		blr

#********************************************************************************************

SPrintF68K68K:

		li	r3,0
		blr

#********************************************************************************************

AllocXMsg68K:

		li	r3,0
		blr

#********************************************************************************************

FreeXMsg68K:

		li	r3,0
		blr

#********************************************************************************************

PutXMsg68K:

		li	r3,0
		blr

#********************************************************************************************

GetPPCState68K:

		li	r3,0
		blr

#********************************************************************************************

SetCache68K68K:

		li	r3,0
		blr

#********************************************************************************************

CreatePPCTask68K:

		li	r3,0
		blr

#********************************************************************************************

CausePPCInterrupt68K:

		li	r3,0
		blr

#********************************************************************************************
#********************************************************************************************
Run68K:

		li	r3,0
		blr

#********************************************************************************************

WaitFor68K:

		li	r3,0
		blr

#********************************************************************************************

SPrintF:

		li	r3,0
		blr

#********************************************************************************************

Run68KLowLevel:

		li	r3,0
		blr

#********************************************************************************************

AllocVecPPC:

		li	r3,0
		blr

#********************************************************************************************

FreeVecPPC:

		li	r3,0
		blr

#********************************************************************************************

CreateTaskPPC:

		li	r3,0
		blr

#********************************************************************************************

DeleteTaskPPC:

		li	r3,0
		blr

#********************************************************************************************

FindTaskPPC:

		li	r3,0
		blr

#********************************************************************************************

InitSemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

FreeSemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

AddSemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

RemSemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

ObtainSemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

AttemptSemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

ReleaseSemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

FindSemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

InsertPPC:

		li	r3,0
		blr

#********************************************************************************************

AddHeadPPC:

		li	r3,0
		blr

#********************************************************************************************

AddTailPPC:

		li	r3,0
		blr

#********************************************************************************************

RemovePPC:

		li	r3,0
		blr

#********************************************************************************************

RemHeadPPC:

		li	r3,0
		blr

#********************************************************************************************

RemTailPPC:

		li	r3,0
		blr

#********************************************************************************************

EnqueuePPC:

		li	r3,0
		blr

#********************************************************************************************

FindNamePPC:

		li	r3,0
		blr

#********************************************************************************************

FindTagItemPPC:

		li	r3,0
		blr

#********************************************************************************************

GetTagDataPPC:

		li	r3,0
		blr

#********************************************************************************************

NextTagItemPPC:

		li	r3,0
		blr

#********************************************************************************************

AllocSignalPPC:

		li	r3,0
		blr

#********************************************************************************************

FreeSignalPPC:

		li	r3,0
		blr

#********************************************************************************************

SetSignalPPC:

		li	r3,0
		blr

#********************************************************************************************

SignalPPC:

		li	r3,0
		blr

#********************************************************************************************

WaitPPC:

		li	r3,0
		blr

#********************************************************************************************

SetTaskPriPPC:

		li	r3,0
		blr

#********************************************************************************************

Signal68K:

		li	r3,0
		blr

#********************************************************************************************

SetCache:

		li	r3,0
		blr

#********************************************************************************************

SetExcHandler:

		li	r3,0
		blr

#********************************************************************************************

RemExcHandler:

		li	r3,0
		blr

#********************************************************************************************

Super:

		li	r3,0
		blr

#********************************************************************************************

User:

		li	r3,0
		blr

#********************************************************************************************

SetHardware:

		li	r3,0
		blr

#********************************************************************************************

ModifyFPExc:

		li	r3,0
		blr

#********************************************************************************************

WaitTime:

		li	r3,0
		blr

#********************************************************************************************

ChangeStack:

		li	r3,0
		blr

#********************************************************************************************

LockTaskList:

		li	r3,0
		blr

#********************************************************************************************

UnLockTaskList:

		li	r3,0
		blr

#********************************************************************************************

SetExcMMU:

		li	r3,0
		blr

#********************************************************************************************

ClearExcMMU:

		li	r3,0
		blr

#********************************************************************************************

ChangeMMU:

		li	r3,0
		blr

#********************************************************************************************

GetInfo:

		li	r3,0
		blr

#********************************************************************************************

CreateMsgPortPPC:

		li	r3,0
		blr

#********************************************************************************************

DeleteMsgPortPPC:

		li	r3,0
		blr

#********************************************************************************************

AddPortPPC:

		li	r3,0
		blr

#********************************************************************************************

RemPortPPC:

		li	r3,0
		blr

#********************************************************************************************

FindPortPPC:

		li	r3,0
		blr

#********************************************************************************************

WaitPortPPC:

		li	r3,0
		blr

#********************************************************************************************

PutMsgPPC:

		li	r3,0
		blr

#********************************************************************************************

GetMsgPPC:

		li	r3,0
		blr

#********************************************************************************************

ReplyMsgPPC:

		li	r3,0
		blr

#********************************************************************************************

FreeAllMem:

		li	r3,0
		blr

#********************************************************************************************

CopyMemPPC:

		li	r3,0
		blr

#********************************************************************************************

AllocXMsgPPC:

		li	r3,0
		blr

#********************************************************************************************

FreeXMsgPPC:

		li	r3,0
		blr

#********************************************************************************************

PutXMsgPPC:

		li	r3,0
		blr

#********************************************************************************************

GetSysTimePPC:

		li	r3,0
		blr

#********************************************************************************************

AddTimePPC:

		li	r3,0
		blr

#********************************************************************************************

SubTimePPC:

		li	r3,0
		blr

#********************************************************************************************

CmpTimePPC:

		li	r3,0
		blr

#********************************************************************************************

SetReplyPortPPC:

		li	r3,0
		blr

#********************************************************************************************

SnoopTask:

		li	r3,0
		blr

#********************************************************************************************

EndSnoopTask:

		li	r3,0
		blr

#********************************************************************************************

GetHALInfo:

		li	r3,0
		blr

#********************************************************************************************

SetScheduling:

		li	r3,0
		blr

#********************************************************************************************

FindTaskByID:

		li	r3,0
		blr

#********************************************************************************************

SetNiceValue:

		li	r3,0
		blr

#********************************************************************************************

TrySemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

AllocPrivateMem:

		li	r3,0
		blr

#********************************************************************************************

FreePrivateMem:

		li	r3,0
		blr

#********************************************************************************************

ResetPPC:

		li	r3,0
		blr

#********************************************************************************************

NewListPPC:

		li	r3,0
		blr

#********************************************************************************************

SetExceptPPC:

		li	r3,0
		blr

#********************************************************************************************

ObtainSemaphoreSharedPPC:

		li	r3,0
		blr

#********************************************************************************************

AttemptSemaphoreSharedPPC:

		li	r3,0
		blr

#********************************************************************************************

ProcurePPC:

		li	r3,0
		blr

#********************************************************************************************

VacatePPC:

		li	r3,0
		blr

#********************************************************************************************

CauseInterrupt:

		li	r3,0
		blr

#********************************************************************************************

CreatePoolPPC:

		li	r3,0
		blr

#********************************************************************************************

DeletePoolPPC:

		li	r3,0
		blr

#********************************************************************************************

AllocPooledPPC:

		li	r3,0
		blr

#********************************************************************************************

FreePooledPPC:

		li	r3,0
		blr

#********************************************************************************************

RawDoFmtPPC:

		li	r3,0
		blr

#********************************************************************************************

PutPublicMsgPPC:

		li	r3,0
		blr

#********************************************************************************************

AddUniquePortPPC:

		li	r3,0
		blr

#********************************************************************************************

AddUniqueSemaphorePPC:

		li	r3,0
		blr

#********************************************************************************************

IsExceptionMode:

		li	r3,0
		blr

#********************************************************************************************

CreateMsgFramePPC:

		li	r3,0
		blr

#********************************************************************************************

SendMsgFramePPC:

		li	r3,0
		blr

#********************************************************************************************

FreeMsgFramePPC:

		li	r3,0
		blr

#********************************************************************************************
#********************************************************************************************

		.rodata

#********************************************************************************************

LibName:		
.byte	"powerpc.library",0
ExpLib:
.byte	"expansion.library",0
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
