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
.set FreePooled,		168
.set FreeVec,			172
.set Insert,			188
.set RemHead,			208
.set Remove,			216
.set RemTail,			220
.set Disable,			248
.set Enable,			252
.set FindTask,			260
.set SetSignal,			288
.set AddSemaphore,		348
.set AttemptSemaphore,		352
.set FindSemaphore,		360
.set InitSemaphore,		364
.set ObtainSemaphore,		368
.set ReleaseSemaphore,		384
.set RemSemaphore,		392
.set OpenLibrary,		424
.set CloseLibrary,		428
.set GetInterface,		448
.set DropInterface,		456
.set CacheClearE,		492
.set OpenDevice,		504
.set SuperState,		576
.set UserState,			580
.set SetTaskTrap,		588
.set AllocSysObjectTags,	704
.set EmulateTags,		744
.set GetCPUInfoTags,		768

# Timer
.set SubTime,			80
.set GetSysTime,		92

# Expansion
.set GetMachineInfoTags,	168
