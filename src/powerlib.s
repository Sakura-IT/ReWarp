
.include	ppcdefines.i
.include	emulation.i
#.set __amigaos4__,0

#********************************************************************************************

			.text

#********************************************************************************************
		
_start:
			li	r3,-1
			blr

#********************************************************************************************

INITFUNC:								#r3 = base, r4 = seglist, r5 = exec interface
			lis		r9,LibName@ha
			li		r0,NT_LIBRARY
			stw		r4,36(r3)
			addi		r9,r9,LibName@l
			stb		r0,LN_TYPE(r3)
			li		r0,LIBF_SUMUSED|LIBF_CHANGED
			stw		r9,LN_NAME(r3)
			li		r9,18
			li		r11,0
			sth		r9,lib_Version(r3)
			lis		r9,IDString@ha
			stb		r0,lib_Flags(r3)
			addi		r9,r9,IDString@l
			li		r0,0
			stb		r11,LN_PRI(r3)
			sth		r0,lib_Revision(r3)
			stw		r9,lib_IdString(r3)
			blr

#********************************************************************************************

IObtain:
		mr		r9,r3
		lwz 		r3,20(r9)
		addi		r3,r3,1
		stw		r3,20(r9)
		blr

#********************************************************************************************

IRelease:
		mr		r9,r3
		lwz 		r3,20(r9)
		addi		r3,r3,-1
		stw		r3,20(r9)
		blr

#********************************************************************************************

IOpen:	
		stwu		r1,-16(r1)
		stw		r31,12(r1)
		lwz		r31,16(r3)
		lhz		r9,32(r31)
		addi		r9,r9,1
		sth		r9,32(r31)
		mr		r3,r31
		lwz		r31,12(r1)
		addi		r1,r1,16
		blr

#********************************************************************************************

IClose:	
		li		r3,0
		blr

#********************************************************************************************

IExpunge:
		li		r3,0
		blr

#********************************************************************************************
#********************************************************************************************

Open68K:
		li		r3,0
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

		li		r3,0
		blr

#********************************************************************************************

RunPPC68K:

		li	r3,0
		blr

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
.byte	18										#RT_VERSION
.byte	NT_LIBRARY								#RT_TYPE
.byte	0										#RT_PRI
.ualong	LibName
.ualong	IDString
.ualong	CreateLibTags

.align	2

#********************************************************************************************

CreateLibTags:
.long	CLT_DataSize,40,CLT_Interfaces,INTERFACETABLE,CLT_InitFunc,INITFUNC,CLT_Vector68K,VECTOR68K,TAG_DONE,0

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
.long	-1

#********************************************************************************************

Open:				jmp Open68K
Close:				jmp Close68K
Expunge:				jmp Expunge68K
Reserved:			jmp Reserved68K
RunPPC:				jmp RunPPC68K
WaitForPPC:			jmp	WaitForPPC68K
GetCPU:				jmp	GetCPU68K
PowerDebugMode:		jmp	PowerDebugMode68K
AllocVec32:			jmp	AllocVec3268K
FreeVec32:			jmp	FreeVec3268K
SPrintF68K:			jmp	SPrintF68K68K
AllocXMsg:			jmp AllocXMsg68K
FreeXMsg:			jmp	FreeXMsg68K
PutXMsg:				jmp	PutXMsg68K
GetPPCState:			jmp GetPPCState68K
SetCache68K:			jmp SetCache68K68K
CreatePPCTask:		jmp CreatePPCTask68K
CausePPCInterrupt:		jmp CausePPCInterrupt68K

#********************************************************************************************
#********************************************************************************************
