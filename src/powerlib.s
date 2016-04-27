
.include	ppcdefines.i
.include	emulation.i
.include	ppcmacros-std.i

#.set __amigaos4__,0

#********************************************************************************************

			.text

#********************************************************************************************
		
_start:
			li	r3,-1
			blr

#********************************************************************************************

INITFUNC:	#r3 = base, r4 = seglist, r5 = exec interface
		lis	r9,LibName@ha
		li	r0,NT_LIBRARY
		stw	r4,libwarp_SegList(r3)
		addi	r9,r9,LibName@l
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
		blr

#********************************************************************************************

IObtain:
		mr	r9,r3
		lwz 	r3,20(r9)
		addi	r3,r3,1
		stw	r3,20(r9)
		blr

#********************************************************************************************

IRelease:
		mr	r9,r3
		lwz	r3,20(r9)
		addi	r3,r3,-1
		stw	r3,20(r9)
		blr

#********************************************************************************************

IOpen:	
		stwu	r1,-16(r1)
		stw	r31,12(r1)
		lwz	r31,16(r3)
		lhz	r9,32(r31)
		addi	r9,r9,1
		sth	r9,32(r31)
		mr	r3,r31
		lwz	r31,12(r1)
		addi	r1,r1,16
		blr

#********************************************************************************************

IClose:	
		li	r3,0
		blr

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
		lwz	r30,PP_REGS+12*4(r16)
		lwz	r31,PP_REGS+13*4(r16)
		
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
