#SingleInstance Force
#MaxThreadsPerHotkey 2
#NoEnv
#Warn All
SetWorkingDir %A_ScriptDir% 
SetKeyDelay -1,-1,-1
SetBatchLines -1
#Include classMemory.ahk
;PACKETVER := 20181104
PACKETVER := 20151104
#Include ragaddr.ahk
CoordMode Mouse|Pixel, Screen

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; setup variables below

HOTKEY_ABRA := "{F1}"
HOTKEY_CASTCANCEL := "{F2}"
HOTKEY_INDULGE := "{F3}"
HOTKEY_SIGHT := "{F4}"
HOTKEY_YGGSEED := "{F9}"
HOTKEY_ATDIE := "" ; make sure it's just 1 key, or itll mess up a lot
HOTKEY_TOTOWN := "2"
USE_ATDIE := false
USE_INDULGE := true ; will auto set to false for sages, but if you dont intend to use it as a prof, set to false

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

SKID_SA_CLASSCHANGE := 292
EFST_POSTDELAY := 46

EFST_HIDING := 4
EFST_TRICKDEAD := 29
EFST_AUTOCOUNTER := 43
EFST_STEELBODY := 87

BadEfst = [EFST_TRICKDEAD, EFST_AUTOCOUNTER, EFST_STEELBODY]

if (_ClassMemory.__Class != "_ClassMemory")
{
	msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
	ExitApp
}

ADDR_OPTION := g_addrOption
ADDR_JOB := g_addrJobID
ADDR_ADELAY := g_addrDelayASPD
ADDR_DEF := ADDR_ADELAY+0x10
ADDR_CHP := g_addrCHP
ADDR_MHP := ADDR_CHP+0x4
ADDR_CSP := ADDR_MHP+0x4
ADDR_MSP := ADDR_CSP+0x4


g_exe := Array()
gamemodeP := Array()
worldP := Array()
playerP := Array()
numPID := Array()
efstlist_start := []
efstlist_end := []
efstlist_count := []
current_index := []
current_efst := []

iterations := []
running := false


^1::
{
	if (running)
	{
		Reload
	}
	
	running := true
	num := StrReplace(A_ThisHotkey, "^", "")
	
	WinGet procid, PID, A
	
	lastexe := new _ClassMemory(procid, "", hProcessCopy)
	if (ErrorLevel)
		MsgBox ClassMemory errorlevel: %ErrorLevel%
	if (A_LastError)
		MsgBox ClassMemory LastError: %A_LastError%
	if !isObject(lastexe) 
	{
		msgbox failed to open a handle
		if (hProcessCopy = 0)
			msgbox The program isn't running (not found) or you passed an incorrect program identifier parameter. In some cases _ClassMemory.setSeDebugPrivilege() may be required. 
		else if (hProcessCopy = "")
			msgbox OpenProcess failed. If the target process has admin rights, then the script also needs to be ran as admin. _ClassMemory.setSeDebugPrivilege() may also be required. Consult A_LastError for more information.
		ExitApp
	}
	
	g_exe.Insert(lastexe)
	
	gamemodeP.InsertAt(num, g_exe[num].read(ADDR_g_modeMgr+OFFSET_CModeMgr__m_curMode))
	worldP.InsertAt(num, g_exe[num].read(gamemodeP[num]+OFFSET_CGameMode__m_world))
	playerP.InsertAt(num, g_exe[num].read(worldP[num]+OFFSET_CWorld__m_player))

	iterations[num] := 0
	Loop
	{
		iterations[num]++
		
		if (iterations[num] >= 5)
		{
			if (Floor(g_exe[num].read(ADDR_CHP)*100/g_exe[num].read(ADDR_MHP)) <= 11 || g_exe[num].read(ADDR_CSP) <= 10)
			{
				ControlSend ,,%HOTKEY_YGGSEED%, % "ahk_pid " g_exe[num].PID
				Sleep 300
			}
			
			if (g_exe[num].read(ADDR_CSP) < 100)
			{
				Loop 2
				{
					ControlSend ,,%HOTKEY_INDULGE%,% "ahk_pid " g_exe[num].PID
					Sleep g_exe[num].read(g_addrDelayASPD)
				}
			}
			
			iterations[num] := 0
		}
		if ( (g_exe[num].read(ADDR_OPTION)&1) == 0)
		{
			ControlSend ,,%HOTKEY_SIGHT%,% "ahk_pid " g_exe[num].PID
			Sleep g_exe[num].read(g_addrDelayASPD)
		}
		
		ControlSend ,,%HOTKEY_ABRA%,% "ahk_pid " g_exe[num].PID
		Sleep 150
		
		if (g_exe[num].read(playerP[num]+OFFSET_CGameActor__m_skillRechargeGage) != 0)
		{
			ControlSend ,,%HOTKEY_CASTCANCEL%,% "ahk_pid " g_exe[num].PID
			Sleep g_exe[num].read(g_addrDelayASPD)
		}
		
		if (g_exe[num].read(gamemodeP[num]+OFFSET_CGameMode__m_skillUseInfo+OFFSET_SKILL_USE_INFO__m_skillId) = SKID_SA_CLASSCHANGE)
		{
			SoundPlay READY1.mp3
			running := false
			FlashWindow(g_exe[num].PID)
			return
		}
		
		; it seems to only open the autocast wnd.. for some reason here
		; so we only search this
		
		teleWndP := g_exe[num].read(ADDR_g_windowMgr+OFFSET_UIWindowMgr__m_spellListWnd)
		
		if (teleWndP != 0)
		{
			wndX := g_exe[num].read(teleWndP+OFFSET_UIWindow__m_x)
			wndY := g_exe[num].read(teleWndP+OFFSET_UIWindow__m_y)
			wndW := g_exe[num].read(teleWndP+OFFSET_UIWindow__m_w)
			wndH := g_exe[num].read(teleWndP+OFFSET_UIWindow__m_h)
			WinActivate % "ahk_pid " g_exe[num].PID
			clickX := wndX+wndW-25
			clickY := wndY+wndH-10
			MouseMove clickX, clickY
			Click %clickX%, %clickY%
			teleWndP = 0
			clickX = clickY = wndX = wndY = wndW = wndH = 0
		}
		
		efstlist_start[num] := g_exe[num].read(ADDR_stateId_first)
		efstlist_end[num] := g_exe[num].read(ADDR_stateId_last)
		efstlist_count[num] := Floor((efstlist_end[num] - efstlist_start[num]) / DIFF_Efst)
		current_index[num] := 0
		while (efstlist_count[num] > 0)
		{
			current_efst[num] := g_exe[num].read(efstlist_start[num]+current_index[num]*DIFF_Efst)
			if (HasVal(BadEfst, current_efst[num]))
			{
				WinActivate % "ahk_pid " g_exe[num].PID
				;PushKey(g_exe[num], HOTKEY_TOTOWN)
				ControlSend ,,%HOTKEY_TOTOWN%,% "ahk_pid " g_exe[num].PID
				return
			}
			efstlist_count[num]--
			current_index[num]++
		}
		
	}
	
	return
}

#R::
{
	Reload
	return
}


HasVal(haystack, needle)
{
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; punches the damn hotkey
PushKey(exe, key)
{
	
	if (!exe.PID || !key)
	{
		MsgBox % "Error ! No proc ID or key found?! Please Reload"
		ListVars
		Exit
	}
	
	ControlSend ,,% key,% "ahk_pid " exe.PID
}
FlashWindow(procid)
{
	if (WinActive("ahk_pid " procid))
		return
	WinGet hWnd, ID,% "ahk_pid " procid
	Static A64 := (A_PtrSize = 8 ? 4 : 0) ; alignment for pointers in 64-bit environment
	Static cbSize := 4 + A64 + A_PtrSize + 4 + 4 + 4 + A64
	VarSetCapacity(FLASHWINFO, cbSize, 0) ; FLASHWINFO structure
	Addr := &FLASHWINFO
	Addr := NumPut(cbSize,    Addr + 0, 0,   "UInt")
	Addr := NumPut(hWnd,      Addr + 0, A64, "Ptr")
	Addr := NumPut(2,   Addr + 0, 0,   "UInt")
	Addr := NumPut(1,    Addr + 0, 0,   "UInt")
	Addr := NumPut(0, Addr + 0, 0,   "Uint")
	Return DllCall("User32.dll\FlashWindowEx", "Ptr", &FLASHWINFO, "UInt")
}

