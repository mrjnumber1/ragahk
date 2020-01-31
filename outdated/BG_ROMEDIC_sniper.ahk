; dont touch these
#SingleInstance Force
#MaxThreadsPerHotkey 1
#NoEnv
#Warn All
SetWorkingDir %A_ScriptDir% 
SetKeyDelay -1,-1,-1
SetBatchLines -1
#Include classMemory.ahk

aspdDelay := 250
gearChangeDelay := 150

/*
 SPEC - 
 http://i.imgur.com/nUihRbV.png

sniper:

fas spam
fa spam
ds spam
bb spam
as>ts> spam

(long lasting) ac>awake>ts>cake>abrasive
(short lasting) aloe>resentment in1

shield > fberet > defweapon
kvmbow > holy arrow > atkhat
compbow > sleep arrow > defhat
earthbow > stone arrow > atkhat
brooch > hide
ring > magnum > medal

*/


; SPECIAL NOTE: if the following use an F key, they should be bracketed, "{F1}" for example

; gears
hkGrCranial			:= "q"
hkGrCombatKnife		:= "w" ; if you dont have one, set this to ""
hkGrHatDef			:= "e"
hkGrHatAtk			:= "r"

hkGrMedal			:= "s"
hkGrMagnum			:= "x"
hkGrHide			:= "c"

hkGrArrowSleep		:= "{F8}"
hkGrBowStatus		:= "{F9}"

hkGrBowEarthen		:= "o"
hkGrArrowStone		:= "l"

hkGrBowAtk			:= "."
hkGrArrowHoly		:= ","
; these are the keys you push after being stripped !
;gearKeys := Array(hkGrMuffler, hkGrShield, hkGrArmor, hkGrHatReg, hkGrShoe, hkGrGuitar)

; SPECIAL NOTE: if the following use an F key, they should be bracketed, "{F1}" for example
; items
hkItHpPot			:= "{F1}"
hkItSpPot			:= "{F2}"
HkItGpPot			:= "{F2}"
hkItBOS				:= "d"
hkItSpeedPotion		:= "f"
hkItASPDPotion		:= "{F3}"
hkItStrawberryCake	:= "{F4}"
hkItAbrasive		:= "{F5}"
hkItAtkFood			:= "{F6}"
hkItProvoke			:= "{F7}"

;skills
hkSkHide			:= "v"
hkSkMagnum			:= "z"

hkSkDS				:= "g"
hkSkFAS				:= "h"
hkSkShower			:= "k"
hkSkFA				:= "b"
hkSkBB				:= "n"

hkSkTS				:= "j"
hkSkAC				:= "a"
	
; hotkeys for what you want to do

hkScDS				:= normalizeHkStr(hkSkDS)
hkScFAS				:= normalizeHkStr(hkSkFAS)
hkScFA				:= normalizeHkStr(hkSkFA)
hkScBB				:= normalizeHkStr(hkSkBB)

hkScShower			:= normalizeHkStr(hkSkShower)

hkScPreHero			:= normalizeHkStr(hkGrMagnum)
hkScHide			:= normalizeHkStr(hkSkHide)

hkScTankup			:= normalizeHkStr(hkGrCranial)
hkScBos				:= normalizeHkStr(hkItBOS)
hkScPostDispel		:= normalizeHkStr(hkItASPDPotion)

hkScKvmAtk := normalizeHkStr(hkGrBowAtk)
hkScEarthAtk := normalizeHkStr(hkGrBowEarthen)
hkScStatusAtk := normalizeHkStr(hkGrBowStatus)


; ROMEDIC OPTIONS

rom_toggleKey		:= "#p" ; no brackets necessary, nor $ qualifier
rom_hpKey 			:= hkItHpPot 
rom_spKey			:= hkItSpPot
rom_gpKey			:= hkItGpPot

rom_hpPercent		:= 99
rom_spPercent		:= 35
rom_useGP			:= 1
rom_woeMode			:= 0 ; 1 = only in xxx/g_cas/0# or are/na_0/#
rom_inactivityDelay := 2000
rom_sleepDelay		:= 1 ; can probably use like, 10 ms sleep time and be fine heh

rom_running			:= 0 ; will be set to 1 within the script, dont change
rom_woeMaps := Array(0x61635F67, 0x305F616E)
	
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; internal variables below
g_addrMapName:=0x10D856C+3 ; +3 == xxxg_cax##
g_addrOPT2 := 0x10D8CF0
g_addrOption := g_addrOPT2+4
g_addrJobID := 0x010D93D8
g_addrDelayASPD := 0x010D9464
g_addrCHP  := 0x10DCE10
g_addrMHP  := g_addrCHP+4
g_addrCSP  := g_addrMHP+4
g_addrMSP  := g_addrCSP+4
g_addrCharName := 0x10DF5D8
g_addrWeaponIID		:= 0x010D8CC4
g_addrShieldIID		:= 0x010D8CC8

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
	WinGet thisPID, PID, A
	if (_ClassMemory.__Class != "_ClassMemory")
	{
		msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
		ExitApp
	}
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
	
	If ( readInt(g_addrJobID) != 4012)
	{
		MsgBox % "Warning!! This macro is made for SNIPER only, and your job id was detected as not being such!"
	}
	Hotkey IfWinActive, ahk_pid %thisPID%
	Hotkey %rom_toggleKey%, ROM_toggle
	Hotkey %hkScPostDispel%, PostDispel
	Hotkey %hkScBos%, BosSpammer
	Hotkey %hkScHide%, AutoHide
	Hotkey %hkScDS%, SpamDS
	Hotkey %hkScFAS%, SpamFAS
	Hotkey %hkScFA%, SpamFA
	Hotkey %hkScBB%, SpamBB
	Hotkey %hkScShower%, SpamShower
	Hotkey %hkScPreHero%, PreHero
	Hotkey %hkScTankup%, TankUp
	Hotkey %hkScKvmAtk%, AtkKvm
	Hotkey %hkScEarthAtk%, AtkEarth
	Hotkey %hkScStatusAtk%, AtkStatus

	Hotkey ^S, SetSuspend
	Hotkey ^R, SetReload
	OnExit ExitSub
	
	rom_running := 1
	SetTimer ROM_timer, %rom_sleepDelay%
    Return
}

SpamFA:
SpamBB:
{
	weapon := readInt(g_addrWeaponIID) & 0xFFFF
	if (hkGrCombatKnife != "" && weapon != 1228) 
	{
		GoSub TankUp
	}
	StringReplace strippedKey, A_ThisHotkey, $
	
	Loop
	{
		if (!GetKeyState(strippedKey, "P"))
			break
		PushKey(StrippedKey)
		ControlClick ,,ahk_pid %thisPID%
	}
	
	return
}
SpamShower:
{
	weapon := readInt(g_addrWeaponIID) & 0xFFFF
	if (weapon < 1700) ; bow start item ids is around 1700!
	{
		PushKey(hkGrBowAtk)
		Sleep %gearChangeDelay%
		PushKey(hkGrArrowHoly)
	}
	
	StringReplace strippedKey, A_ThisHotkey, $
	Loop
	{
		if (!GetKeyState(strippedKey, "P"))
			break
		
		PushKey(hkSkTS)
		Sleep getASPDDelay()
		PushKey(StrippedKey)
		ControlClick ,,ahk_pid %thisPID%
		Sleep getASPDDelay()
	}

	return
}

SpamDS:
SpamFAS:
{	
	weapon := readInt(g_addrWeaponIID) & 0xFFFF
	
	if (weapon < 1700) ; bow start item ids is around 1700!
	{
		PushKey(hkGrBowEarthen)
		Sleep %gearChangeDelay%
		PushKey(hkGrArrowStone)
	}
	StringReplace strippedKey, A_ThisHotkey, $
	
	Loop
	{
		if (!GetKeyState(strippedKey, "P"))
			break
		
		PushKey(StrippedKey)
		ControlClick ,,ahk_pid %thisPID%
		
	}
	
	return
}

AtkKvm:
{
	kvmGears := Array(hkGrBowAtk, hkGrHatAtk, hkGrArrowHoly)
	Loop % kvmGears.MaxIndex()
	{
		PushKey(kvmGears[A_Index])
		Sleep %gearChangeDelay%
	}
	
	return
}
AtkEarth:
{
	earthGears := Array(hkGrBowEarthen, hkGrHatAtk, hkGrArrowStone)
	Loop % earthGears.MaxIndex()
	{
		PushKey(earthGears[A_Index])
		Sleep %gearChangeDelay%
	}
	return
}
AtkStatus:
{
	statusGears := Array(hkGrBowStatus, hkGrHatDef, hkGrArrowSleep)
	Loop % statusGears.MaxIndex()
	{
		PushKey(statusGears[A_Index])
		Sleep %gearChangeDelay%
	}
	
	return
}
TankUp:
{
	tankGears := Array(hkGrCranial, hkGrHatDef, hkGrCombatKnife)
	
	Loop % tankGears.MaxIndex()
	{
		PushKey(tankGears[A_Index])
		Sleep %gearChangeDelay%
	}
	
	return
}

PostDispel:
{
	postdispelItems := Array(hkItASPDPotion, hkItStrawberryCake, hkItAbrasive, hkSkAC, hkSkTS)
	
	Loop % postdispelItems.MaxIndex()
	{
		PushKey(postdispelItems[A_Index])
		Sleep getASPDDelay()
	}
	
	GoSub BosSpammer
	
	return
}

PreHero:
{
	preheroItems := Array(hkGrMagnum, hkSkMagnum, hkGrMedal, hkItAtkFood, hkItProvoke, hkSkTS)
	
	Loop % preheroItems.MaxIndex()
	{
		PushKey(preheroItems[A_Index])
		Sleep getASPDDelay()
	}
	
	return
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
	
	SetTimer BosSpammer, 29500
	return
}

AutoHide:
{
	PushKey(hkSkHide)
	Sleep 150	
	
	Loop 2 
	{
		isHiding := readInt(g_addrOption) & 0x2

		If (isHiding == 2)
		{
			Break
		}
		
		PushKey(hkGrHide)
		Sleep %gearChangeDelay%
		PushKey(hkSkHide)
		Sleep getASPDDelay()
	
		Continue
	}
	
	Return
}

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
SetSuspend:
{
	Suspend
	SetTimer BosSpammer, Off
	rom_running := 0
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
; adds 5 ms for a bit of precision
; update interval by default is 2000 ms
getASPDDelay()
{
	Global tick, aspdDelay, g_addrDelayASPD
	
	;Return 500
	If ( (A_TickCount - tick) >= 2000 ) ;update interval of 2 sec
	{
		tick := A_TickCount
		aspdDelay := 2 * readInt(g_addrDelayASPD) + 5
	}
	
	Return aspdDelay
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
		MsgBox % "HP pot isn't a percentvalue: " . rom_hpPercent
		return 0
	}
	
	if ( rom_spPercent > 99 || rom_spPercent < 0 )
	{
		MsgBox % "SP pot isn't a percent. val: " . rom_spPercent
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
	Global thisPID, rom_woeMode, rom_woeMaps, rom_inactivityDelay, rom_hpKey, rom_spKey, rom_gpKey, rom_spPercent, rom_hpPercent, rom_useGP
	
	addrMapName:=0x10D856C+3 ; +3 == xxxg_cax##
	addrOPT2 := 0x10D8CF0
	addrOption := addrOPT2+4
	addrJobID := 0x010D93D8
	addrDelayASPD := 0x010D9464
	addrCHP  := 0x10DCE10
	addrMHP  := addrCHP+4
	addrCSP  := addrMHP+4
	addrMSP  := addrCSP+4
	addrCharName := 0x10DF5D8
	
	badStatus := 0x2|0x4|0x10 ; OPT2_CURSE = 0x0002,OPT2_SILENCE = 0x0004, OPT2_BLIND = 0x0010,

	IfWinNotExist ahk_pid %thisPID%
	{
		thisPID := 0
		MsgBox % "Window not found! Please reload with it open and win+Start again"
		exit
		return
	}

	mapNum := readInt(addrMapName+3)
	
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
	
	hpCur := readInt(addrCHP)
	hpMax := readInt(addrMHP)
	
	if ( rom_hpPercent > 0 )
	{
		if ( Floor(hpCur * 100 / hpMax) <= rom_HpPercent)
		{
			PushKey(rom_hpKey)
		}
	}
	
	if ( rom_spPercent > 0)
	{
		spCur := readInt(addrCSP)
		spMax := readInt(addrMSP)
		if ( Floor(spCur * 100 / spMax) <= rom_spPercent)
		{
			Loop 5
			{
				PushKey(rom_spKey)
				Sleep 100
			}
		}
	}
	
	if (rom_useGP > 0)
	{
		opt2Cur := readInt(addrOPT2)
		
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
		return
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

	return
}