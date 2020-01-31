SetBatchLines -1
SetKeyDelay -1,-1,-1
#MaxThreadsPerHotkey 1

^S::
{
	ExitApp
	return
}


#S::
	MsgBox % "Put your mouse over the dye npc before hitting OK. press ctrl+s when youre out of dyestuff materials. Trying 30 times"
	ATTEMPTS := 30
	DELAY_NPC := 350
	; 0 scarlet
	; 1 lemon
	; 2 cobaltblue
	; 3 darkgreen
	; 4 orange
	; 5 violet
	; 6 white
	; 7 black
	CHOICE := 0
	
	
	
	Loop %ATTEMPTS%
	{
		Click
		Sleep %DELAY_NPC%
		Send {Enter}
		Sleep %DELAY_NPC%
		Send {Down}
		Sleep %DELAY_NPC%
		Loop 4
		{
			Send {Enter}
			Sleep %DELAY_NPC%
		}
		
		Loop %CHOICE%
		{
			Send {Down}
			Sleep 200
		}
		
		Loop 6
		{
			Send {Enter}
			Sleep %DELAY_NPC%
		}
	}
		

return