#ifWinActive https://nostalgy
#HotkeyInterval 2000 ; This is the default value (milliseconds).
#MaxHotkeysPerInterval 1000000000
SetBatchLines -1
SetKeyDelay -1,-1,-1
#MaxThreadsPerHotkey 1

^S::
{
	ExitApp
	return
}


F4::
	npcDelay := 350
	Loop 20
	{
		Click
		Sleep %npcDelay%
		Send {Enter}
		Sleep %npcDelay%
		Send {Down}
		Sleep %npcDelay%
		Loop 10
		{
			Send {Enter}
			Sleep %npcDelay%
		}
	}	

return