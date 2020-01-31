#SingleInstance Force
#MaxThreadsPerHotkey 2
#NoEnv
#Warn All
SetWorkingDir %A_ScriptDir% 
SetKeyDelay -1,-1,-1
SetBatchLines -1
PACKETVER := 20151104
#Include ragaddr.ahk
#Include classMemory.ahk

;simple delays, likely dont have to touch these
; todo: if possible, just make it read the internal aspd delay!
aspdDelay := 210
gearChangeDelay := 100
foodDelay := 300

; SPECIAL NOTE: if the following use an F key, they should be bracketed, "{F1}" for example

; gears
hkGrGuitar 			:= "g"
hkGrSpiritGuitar	:= "b"
hkGrCombatKnife		:= "h"
hkGrShield			:= "z"
hkGrHide			:= "c"

; SPECIAL NOTE: if the following use an F key, they should be bracketed, "{F1}" for example
; items

hkItHpPot			:= "{F1}"
hkItSpPot			:= "{F2}"
HkItGpPot			:= "{F2}"
hkItASPDPotion		:= "{F5}"
hkItYgg				:= "{F3}"
hkItFoods 			:= Array("{F6}","{F7}","{F8}","{F9}")
hkItBOS				:= "q"
hkSkService			:= "r"
hkSkFortune			:= "e"
hkSkDFM				:= "w"
hkSkBragi			:= "t"
hkSkRiff			:= "y"
hkSkApples			:= "u"
hkItSpeedPotion		:= "a"
hkSkIC				:= "j"
hkSkFrostJoke		:= "k"
;hkSkScream			:= "l"

;skills
hkSkHide			:= "v"
hkSkDissonance		:= "n"

	
; hotkeys for what you want to do

hkScSongsNormal		:= normalizeHkStr(hkSkBragi)
hkScSongsLinked 	:= normalizeHkStr(hkSkService)
hkScDissoSpam		:= normalizeHkStr(hkSkDissonance)
hkScPostDispel		:= normalizeHkStr(hkSkIC)
hkScUseFood			:= normalizeHkStr(hkItFoods[1])
hkScBos				:= normalizeHkStr(hkItBOS)
hkScJoker			:= normalizeHkStr(hkSkFrostJoke)
;hkScScream			:= normalizeHkStr(hkSkScream)
hkScHide			:= normalizeHkStr(hkSkHide)
hkScTankmode		:= normalizeHkStr(hkGrCombatKnife)
	
songKeys := Array(hkSkBragi, hkSkRiff, hkSkApples, hkSkService, hkSkFortune)
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

isLinked := 0
isSinging := 0

; ROMEDIC OPTIONS

rom_toggleKey		:= "#p" ; no brackets necessary, nor $ qualifier
rom_hpKey 			:= hkItHpPot 
rom_spKey			:= hkItSpPot
rom_gpKey			:= hkItGpPot
rom_ygKey			:= hkItYgg

rom_hpPercent		:= 97
rom_spPercent		:= 50
rom_ygPercent		:= 0
rom_useGP			:= 1
rom_woeMode			:= 0 ; 1 = only in xxx/g_cas/0# or are/na_0/#
rom_inactivityDelay := 2000
rom_sleepDelay		:= 1 ; can probably use like, 10 ms sleep time and be fine heh

rom_running			:= 0 ; will be set to 1 within the script, dont change
rom_woeMaps := Array(0x61635F67, 0x305F616E)
	
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; internal variables below

g_exe := 0
tick := A_TickCount

	    
if ( ROM_CheckConfig() != 1)
{
	MsgBox % "Romedic config is busted. Fix it."
	Exit
}

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#s::
{
	if (_ClassMemory.__Class != "_ClassMemory")
	{
		msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
		ExitApp
	}
	WinGet thisPID, PID, A
	
	g_exe := new _ClassMemory(thisPID, "", hProcessCopy) 
	if (ErrorLevel)
		MsgBox ClassMemory errorlevel: %ErrorLevel%
	if (A_LastError)
		MsgBox ClassMemory LastError: %A_LastError%
	if !isObject(g_exe) 
	{
		msgbox failed to open a handle
		if (hProcessCopy = 0)
			msgbox The program isn't running (not found) or you passed an incorrect program identifier parameter. In some cases _ClassMemory.setSeDebugPrivilege() may be required. 
		else if (hProcessCopy = "")
			msgbox OpenProcess failed. If the target process has admin rights, then the script also needs to be ran as admin. _ClassMemory.setSeDebugPrivilege() may also be required. Consult A_LastError for more information.
		ExitApp
	}
	
	Hotkey IfWinActive, ahk_pid %thisPID%
	Hotkey %rom_toggleKey%, ROM_toggle
	Hotkey %hkScSongsNormal%, NormalSongs
	Hotkey %hkScSongsLinked%, LinkedSongs
	Hotkey %hkScDissoSpam%, DissoSpam
	Hotkey %hkScPostDispel%, PostDispel
	Hotkey %hkScUseFood%, UseFood
	Hotkey %hkScBos%, BosSpammer
	Hotkey %hkScJoker%, FrostJoke
	;Hotkey %hkScScream%, ScreamWhore
	Hotkey ^S, SetSuspend
	Hotkey ^R, SetReload
	OnExit ExitSub
	  
	rom_running := 1
	SetTimer ROM_timer, %rom_sleepDelay%
    Return
}

LinkedSongs:
{

	isLinked := 1
	
NormalSongs:

	songCasts := isLinked > 0 ? 5 : 3 ; bragi -> riff -> apples (->spdance -> fortune)
	
	If ( !isSinging )
	{
		isSinging := 1
		
		Loop
		{
			Loop %songCasts%
			{
				PushKey(hkGrGuitar)
				;Sleep %gearChangeDelay% 
				PushKey(songKeys[A_Index])
				Sleep getASPDDelay()
				If (!isSinging)
					Break
			}
			
			If (!isSinging)
				Break
		}
		
		PushKey(hkGrGuitar)
		
		isLinked := 0
	}
	Else
	{
		isSinging := 0
	}
		
	
	Return
}
DissoSpam:
{

	Loop 5
	{
		Loop 3
			PushKey(hkGrSpiritGuitar)
		Sleep 50
		Loop 3
			PushKey(hkSkDissonance)
	}
	
	Return
}
PostDispel:
{
	Sleep getASPDDelay()
	PushKey(hkSkIC)
	Sleep getASPDDelay()
	PushKey(hkItASPDPotion)
	
	Sleep getASPDDelay()
	GoSub BosSpammer
	Return
}
UseFood:
{

	Loop % hkItFoods.MaxIndex()
	{
		PushKey(hkItFoods[A_Index])
		Sleep %foodDelay%
	}
	
	Return
}
FrostJoke:
{
	PushKey(hkGrSpiritGuitar)
	Sleep 50
	Loop 5
	{
		PushKey(hkSkFrostJoke)
		Sleep getASPDDelay()
	}
	
	Return
}
ScreamWhore:
{
	PushKey(hkGrSpiritGuitar)
	Sleep 50
	Loop 5
	{
		PushKey(hkSkScream)
		Sleep getASPDDelay()
	}
	
	Return
}
BosSpammer:
{
	
	IfWinActive ahk_pid %thisPID%
	{
		PushKey(hkItBOS)
	}
	Else
	{
		WinWaitActive ahk_pid %thisPID%,,12000
		
		if (ErrorLevel == 1)
		{
			MsgBox % "you there hoss? pause your bos spammer and romedic if not!"
			return
		}
		
		PushKey(hkItBOS)
	}
	
	SetTimer BosSpammer, 30000
	Return
}

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
SetSuspend:
{
	Suspend
	SetTimer BosSpammer, Off
	Return
}
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
SetReload:
{
	Reload
	Return
}
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; functions/subs for internal use
ExitSub:
{
	ExitApp 
}
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; cleans up hotkeys (for ControlSends) for use with Hotkey command
; ex: {home} becomes home and {f2} becomes f2}
; it also adds the $ modifier because most hotkeys use themselves
normalizeHkStr(str)
{
	bracketpos := InStr(str, "{")
	If (bracketpos != 0) ; f key or special- please clean up
	{
		str := SubStr(str, bracketpos+1, StrLen(str)-2) ;instr pos start at 1
	}
	str := "$" . str
	
	return str
}
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; returns the user's aspd delay
; adds 10 ms for a bit of precision
getASPDDelay()
{
	Global tick, aspdDelay, g_addrDelayASPD
	
	;Return 500
	If ( (A_TickCount - tick) >= 2000 ) ;update interval of 2 sec
	{
		tick := A_TickCount
		aspdDelay := 2 * readInt(g_addrDelayASPD) + 10
	}
	
	Return aspdDelay
}
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; punches the damn hotkey
PushKey(key)
{
	global thisPID
	
	if (!thisPID || !key)
	{
		MsgBox % "Error ! No proc ID or key found?! Please Reload"
		ListVars
		Exit
	}
	
	ControlSend ,,% key, ahk_pid %thisPID%
}
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; reads the integer obtained from param addr
readInt(addr)
{
	global g_exe
	
	value := g_exe.read(addr)
	if (ErrorLevel)
		MsgBox g_exe.read errorlevel: %ErrorLevel%
	if (A_LastError)
		MsgBox g_exe.read LastError: %A_LastError%

	Return value
}

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ROM_CheckConfig()
{
	Global
	
	if ( rom_hpPercent > 99 || rom_hpPercent < 0 )
	{
		MsgBox % "HP pot # isn't a percent. value: " . rom_hpPercent
		return 0
	}
	
	if ( rom_spPercent > 99 || rom_spPercent < 0 )
	{
		MsgBox % "SP pot # isn't a percent. val: " . rom_spPercent
		return 0
	}
	
	if ( rom_useGP > 1 || rom_useGP < 0)
	{
		MsgBox % "GP value should be 1 or 0!"
		return 0
	}
	
	if ( rom_woeMode > 1 || rom_woeMode < 0 )
	{
		MsgBox % "WoE mode should be 1 = ON, 0 = OFF"
		return 0
	}
	
	
	return 1
}


ROM_GetStats()
{
	Global thisPID, rom_woeMode, rom_woeMaps, rom_inactivityDelay, rom_hpKey, rom_spKey, rom_gpKey, rom_ygKey, rom_ygPercent, rom_spPercent, rom_hpPercent, rom_useGP, g_addrMapName, g_addrOPT2, g_addrCHP, g_addrMHP, g_addrCSP, g_addrMSP
	
	badStatus := 0x2|0x4|0x10 ; OPT2_CURSE = 0x0002,OPT2_SILENCE = 0x0004, OPT2_BLIND = 0x0010,

	IfWinNotExist ahk_pid %thisPID%
	{
		thisPID := 0
		MsgBox % "Window not found! Please reload with it open and win+Start again"
		exit
		return
	}

	mapNum := readInt(g_addrMapName+3)
	
	if ( rom_woeMode )
	{
		for idx, map in rom_woeMaps
		{
			if (mapNum == map)
				break
		}
		if (idx == rom_woeMaps.Length())
		{
			Sleep %rom_inactivityDelay%
			return
		}
	}
	
	hpCur := readInt(g_addrCHP)
	hpMax := readInt(g_addrMHP)
	
	if (rom_ygPercent > 0)
	{
		if (Floor(hpCur*100/hpMax) <= rom_ygPercent)
		{
			PushKey(rom_ygKey)
		}
	}
	if ( rom_hpPercent > 0 )
	{
		if ( Floor(hpCur * 100 / hpMax) <= rom_HpPercent)
		{
			PushKey(rom_hpKey)
		}
	}
	
	if ( rom_spPercent > 0)
	{
		spCur := readInt(g_addrCSP)
		spMax := readInt(g_addrMSP)
		if ( Floor(spCur * 100 / spMax) <= rom_spPercent)
		{
			PushKey(rom_spKey)
		}
	}
	
	if (rom_useGP > 0)
	{
		opt2Cur := readInt(g_addrOPT2)
		
		if ( (opt2Cur & badStatus) != 0)
		{
			PushKey(rom_gpKey)
		}
	}
	
	return
}


ROM_toggle:
{
	rom_running := !rom_running
	
	if (rom_running != 0)
	{
		SetTimer ROM_timer, %rom_sleepDelay%
	}
	
	return
}
ROM_timer:
{
	Critical
	if (rom_running == 0)
	{
		SetTimer ROM_timer, Off
		Return
	}
		
	IfWinActive ahk_pid %thisPID%
	{
		ROM_GetStats()
	}
	else
	{
		WinWaitActive ahk_pid %thisPID%,,12000
		
		if (ErrorLevel == 1)
		{
			MsgBox % "you there hoss? pause your bos spammer and romedic if not!"
			return
		}
	}

	Return
}