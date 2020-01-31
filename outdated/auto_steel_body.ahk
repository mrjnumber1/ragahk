
HK_MO_STEELBODY := "{s}"
HK_CH_SOULCOLLECT := "{a}"
DELAY_STATUSCHECKS := 5000

; dont touch these
PACKETVER := 20151104
#SingleInstance Force
#MaxThreadsPerHotkey 2
#NoEnv
#Warn 
SetWorkingDir %A_ScriptDir% 
SetKeyDelay -1,-1,-1
SetBatchLines -1
#Include ragaddr.ahk
#Include classMemory.ahk

; for testing only
;EFST_EXPLOSIONSPIRITS := 86
;EFST_STEELBODY := EFST_EXPLOSIONSPIRITS 
EFST_STEELBODY := 87

g_exe := 0
tick := A_TickCount
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
	
	Loop 
	{
		gamemodeP := readInt(ADDR_g_modeMgr+OFFSET_CModeMgr__m_curMode)
		worldP := readInt(gamemodeP+OFFSET_CGameMode__m_world)
		playerP := readInt(worldP+OFFSET_CWorld__m_player)

		efstlist_start := readInt(ADDR_stateId_first)
		efstlist_end := readInt(ADDR_stateId_last)
		efstlist_count := Floor((efstlist_end - efstlist_start) / DIFF_Efst)
		current_index := 0
		current_efst := 0
		
		while (efstlist_count > 0)
		{
			current_efst := readInt(efstlist_start+current_index*DIFF_Efst)
			if (current_efst = EFST_STEELBODY) 
			{
				break
			}
			efstlist_count--
			current_index++
		}
		
		if (current_efst != EFST_STEELBODY) ; broke early, no steel body so lets go
		{
			PushKey(HK_CH_SOULCOLLECT)
			while (readInt(playerP+OFFSET_CGameActor__m_skillRechargeGage) != 0)
			{
				Sleep 100
			}
			Sleep readInt(g_addrDelayASPD)
			PushKey(HK_MO_STEELBODY)
		}
		Sleep %DELAY_STATUSCHECKS%
	}
	return
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
