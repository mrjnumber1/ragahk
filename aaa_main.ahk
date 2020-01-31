#SingleInstance Force
#MaxThreadsPerHotkey 1
#NoEnv
#Warn All
SetWorkingDir %A_ScriptDir% 
SetKeyDelay -1,-1,-1
SetBatchLines -1
#Include lib_common.ahk


^R::
{
	Reload
	return
}

PIDLIST := {"SINGER": 0, "GEM": 0, "PALLY": 0, "TANK": 0, "LINKER": 0, "ASSTLINK": 0, "BOMBER": 0, "PROF": 0}
tmpoutputvar := 0
#S::
{ ; WIN+(S)inger
	WinGet tmpoutputvar, PID, A
	PIDLIST["SINGER"] := tmpoutputvar
	return
}
#I::
{ ; WIN+(I)nto abyss
	WinGet tmpoutputvar, PID, A
	PIDLIST["GEM"] := tmpoutputvar
	return
}
#G::
{ ; WIN+(G)ospel
	WinGet tmpoutputvar, PID, A
	PIDLIST["PALLY"] := tmpoutputvar
	return
}
#T::
{ ; WIN+(T)ank
	WinGet tmpoutputvar, PID, A
	PIDLIST["TANK"] := tmpoutputvar
	return
}
#L::
{ ; WIN+(L)inker
	WinGet tmpoutputvar, PID, A
	PIDLIST["LINKER"] := tmpoutputvar
	return
}
#A::
{ ;WIN+(A)ssist
	WinGet tmpoutputvar, PID, A
	PIDLIST["ASSTLINK"] := tmpoutputvar
	return
}
#B::
{ ; WIN+(B)OMBER
	WinGet tmpoutputvar, PID, A
	PIDLIST["BOMBER"] := tmpoutputvar
	return
}
#H::
{  ; WIN+(H)OCUSER
	WinGet tmpoutputvar, PID, A
	PIDLIST["PROF"] := tmpoutputvar
	return
}
#P::
{  ; WIN+(P)riest
	WinGet tmpoutputvar, PID, A
	PIDLIST["PRIEST"] := tmpoutputvar
	return
}

