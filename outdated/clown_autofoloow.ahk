; dont touch these
#SingleInstance Force
#MaxThreadsPerHotkey 2
#NoEnv
#Warn 
SetWorkingDir %A_ScriptDir% 
SetKeyDelay -1,-1,-1
SetBatchLines -1
PACKETVER := 20151104
#Include ragaddr.ahk
#Include classMemory.ahk


DELAY_GEARCHANGE := 100
DELAY_SONGSWITCH := 2000

HK_GUITAR := "g"
HK_HPPOT := "{F8}"
HK_BLUEPOT := "{F9}"
HK_BA_POEMBRAGI := "t"
HK_BA_ASSNCROSS := "y"
HK_BA_APPLEIDUN := "u"
HK_DC_SERVICE := "r"
HK_DC_FORTUNE := "e"

HK_SONGS := Array(HK_BA_POEMBRAGI, HK_BA_ASSNCROSS, HK_BA_APPLEIDUN, HK_DC_SERVICE)
;HK_SONGS := Array(HK_BA_POEMBRAGI, HK_BA_ASSNCROSS, HK_DC_SERVICE)

SONGCOUNT := HK_SONGS.MaxIndex()


; ROMEDIC OPTIONS
rom_hpKey 			:= HK_HPPOT
rom_spKey			:= HK_BLUEPOT
rom_gpKey			:= 0
rom_ygKey			:= 0

rom_hpPercent		:= 50
rom_spPercent		:= 25
rom_ygPercent		:= 0
rom_useGP			:= 0
rom_woeMode			:= false
rom_inactivityDelay := 2000
rom_sleepDelay		:= 1000 ; can probably use like, 10 ms sleep time and be fine heh

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
#C::
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
	
	rom_running := 1
	SetTimer ROM_timer, %rom_sleepDelay%
	
	Loop 
	{
		Loop %SONGCOUNT%
		{
			PushKey(HK_GUITAR)
			Sleep %DELAY_GEARCHANGE%
			PushKey(HK_SONGS[A_Index])
			Sleep %DELAY_SONGSWITCH%
		}
	}

    Return
}


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
; ROMEDIC SHIT AHEAD
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ROM_CheckConfig()
{
	Global
	
	if ( rom_hpPercent > 99 || rom_hpPercent < 0 )
	{
		MsgBox % "HP pot # is fucked. value: " . rom_hpPercent
		return 0
	}
	
	if ( rom_spPercent > 99 || rom_spPercent < 0 )
	{
		MsgBox % "SP pot # is fuked. val: " . rom_spPercent
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
		
	ROM_GetStats()

	Return
}