# Struct
.set Data_LibBase,		16
.set Data_RefCount,		20

# Main
.set Obtain,			60
.set Release,			64

# Exec
.set AddHead,			76
.set AddTail,			88
.set AllocPooled,		108
.set AllocVec,			112
.set CopyMem,			124
.set CreatePool,		132
.set DeletePool,		140
.set Enqueue,			144
.set FindName,			148
.set FreePooled,		168
.set FreeVec,			172
.set Insert,			188
.set RawDoFmt,			204
.set RemHead,			208
.set Remove,			216
.set RemTail,			220
.set Disable,			248
.set Enable,			252
.set FindTask,			260
.set SetTaskPri,		268
.set AllocSignal,		276
.set FreeSignal,		280
.set SetSignal,			288
.set Signal,			292
.set Wait,			296
.set AddPort,			300
.set FindPort,			320
.set GetMsg,			324
.set PutMsg,			328
.set RemPort,			332
.set ReplyMsg,			336
.set WaitPort,			340
.set AddSemaphore,		348
.set AttemptSemaphore,		352
.set AttemptSemaphoreShared,	356
.set FindSemaphore,		360
.set InitSemaphore,		364
.set ObtainSemaphore,		368
.set ObtainSemaphoreShared,	376
.set Procure,			380
.set ReleaseSemaphore,		384
.set RemSemaphore,		392
.set Vacate,			396
.set DeleteTask,		408
.set OpenLibrary,		424
.set CloseLibrary,		428
.set GetInterface,		448
.set DropInterface,		456
.set CacheClearE,		492
.set CacheClearU,		496
.set OpenDevice,		504
.set CloseDevice,		508
.set AbortIO,			520
.set CheckIO,			524
.set SendIO,			532
.set WaitIO,			540
.set SuperState,		576
.set UserState,			580
.set SetTaskTrap,		588
.set CacheControl,		648
.set AllocSysObjectTags,	704
.set FreeSysObject,		708
.set NewList,			724
.set NewMinList,		728
.set EmulateTags,		744
.set DebugPrintF,		748
.set GetCPUInfoTags,		768

# Timer
.set AddTime,			76
.set SubTime,			80
.set CmpTime,			84
.set GetSysTime,		92

# Expansion
.set GetMachineInfoTags,	168

#Utility
.set FindTagItem,		96
.set GetTagData,		104
.set NextTagItem,		112
.set VASPrintf,			292
.set MoveMem,			312

# Dos
.set FPutC,			292
.set CreateNewProcTags,		432
.set GetEntryData,		788
