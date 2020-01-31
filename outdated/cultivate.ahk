#ifWinActive https://nostalgy
#HotkeyInterval 2000 ; This is the default value (milliseconds).
#MaxHotkeysPerInterval 1000000000
SetBatchLines -1
SetKeyDelay -1,-1,-1
#MaxThreadsPerHotkey 1

HK_CR_CULTIVATE := "{F1}"
HK_MC_CARTREVOLUTION := "{F2}"

#T::
{
	WinGet g_PID, PID, A
	WinGetPos g_screenX, g_screenY, g_screenW, g_screenH, ahk_pid %g_PID%
	CoordMode Mouse|Pixel, Screen
	
	MouseGetPos xpos, ypos	
	PixelGetColor shroomcolor, %xpos%, %ypos%
	MsgBox %shroomcolor%
	
	return
}

#A::
{
	WinGet g_PID, PID, A
	WinGetPos g_screenX, g_screenY, g_screenW, g_screenH, ahk_pid %g_PID%
	CoordMode Mouse|Pixel, Screen

	
	loop
	{

		Loop 5
		{
		PushKey(HK_CR_CULTIVATE)
		Sleep 100
		Click
		}
		Sleep 300
		PushKey(HK_MC_CARTREVOLUTION)
		Sleep 100
		Click
		Sleep 300
		
	}
	return
}


PushKey(key)
{
	global g_PID
	
	if (!g_PID || !key)
	{
		MsgBox % "Error: PID not set!"
		Exit
	}
	ControlSend ,,% key,ahk_pid %g_PID%
}
Pause::
{
	Pause
	return
}
